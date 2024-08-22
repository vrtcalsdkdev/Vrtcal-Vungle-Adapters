// Vungle Banner Adapter, Vrtcal as Primary

import VrtcalSDK

class VRTBannerCustomEventVungle: VRTAbstractBannerCustomEvent {
    private var containerView: UIView?
    var receivedVungleAdPlayabilityUpdate = false
    
    override func loadBannerAd() {
        
        VRTAsPrimaryManager.singleton.initializeThirdParty(
            customEventConfig: customEventConfig
        ) { result in
            switch result {
            case .success():
                self.finishLoadingBanner()
            case .failure(let vrtError):
                self.customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            }
        }
    }

    func finishLoadingBanner() {
        
        guard let placementId = customEventConfig.thirdPartyCustomEventData["adUnitId"] as? String else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "No placement Id"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        let frame = CGRect(
            x: 0,
            y: 0,
            width: customEventConfig.adSize.width,
            height: customEventConfig.adSize.height)
        
        // vungleAdPlayabilityUpdate is often called immediately before Vungle's view is ready
        // So, we return this container view that might not yet have a Vungle
        containerView = UIView(frame: frame)
        
        let error = VRTVungleManager.singleton.loadPlacement(
            withID: placementId,
            with: .banner,
            vrtVungleManagerDelegate: self
        )
        
        if let error {
            let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
    }
    
    override func getView() -> UIView? {
        return containerView
    }
}

// MARK: - VRTVungleManagerDelegate
extension VRTBannerCustomEventVungle: VRTVungleManagerDelegate {

    func vungleAdViewed(forPlacement placementID: String?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventShown()
    }

    func vungleDidCloseAd(forPlacementID placementID: String) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.unknown)
    }

    func vungleDidShowAd(forPlacementID placementID: String?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventShown()
    }

    func vungleRewardUser(forPlacementID placementID: String?) {
        // No VRT analog
        VRTLogInfo()
    }

    func vungleTrackClick(forPlacementID placementID: String?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    func vungleWillCloseAd(forPlacementID placementID: String) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillDismissModal(.unknown)
    }

    func vungleWillLeaveApplication(forPlacementID placementID: String?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillLeaveApplication()
    }

    func vungleWillShowAd(forPlacementID placementID: String?) {
        // No VRT Analog
        VRTLogInfo()
    }

    func vungleAdPlayabilityUpdate(
        _ isAdPlayable: Bool,
        placementID: String?,
        error: Error?
    ) {
        VRTLogInfo("isAdPlayable: \(isAdPlayable), placementID: \(String(describing: placementID)) error: \(String(describing: error))")
        
        guard !receivedVungleAdPlayabilityUpdate else {
            VRTLogInfo("Already received vungleAdPlayabilityUpdate, bailing")
            return
        }
        receivedVungleAdPlayabilityUpdate = true

        if let error {
            let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }

        if !isAdPlayable {
            let vrtError = VRTError(vrtErrorCode: .customEvent, message: "Vungle Ad Not Playable")
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }

        guard let containerView else {
            let vrtError = VRTError(vrtErrorCode: .customEvent, message: "Container view nil")
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        if let error = VRTVungleManager.singleton.showBanner(
            placementId: placementID ?? "",
            inContainerView: containerView
        ) {
            let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }

        customEventLoadDelegate?.customEventLoaded()
    }
}
