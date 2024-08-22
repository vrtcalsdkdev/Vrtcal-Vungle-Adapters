// Vungle Banner Adapter, Vrtcal as Primary

import VrtcalSDK

class VRTInterstitialCustomEventVungle: VRTAbstractInterstitialCustomEvent, VRTVungleManagerDelegate {
    private var placementId: String?

    override func loadInterstitialAd() {
        VRTAsPrimaryManager.singleton.initializeThirdParty(
            customEventConfig: customEventConfig
        ) { result in
            switch result {
            case .success():
                self.finishLoadingInterstitial()
            case .failure(let vrtError):
                self.customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            }
        }
    }
    
    func finishLoadingInterstitial() {
        
        
        VRTLogInfo()
        guard let placementId = customEventConfig.thirdPartyCustomEventDataValueOrFailToLoad(
            thirdPartyCustomEventKey: ThirdPartyCustomEventKey.adUnitId,
            customEventLoadDelegate: customEventLoadDelegate
        ) else {
            return
        }

        self.placementId = placementId

        let error = VRTVungleManager.singleton.loadPlacement(
            withID: placementId,
            with: .unknown,
            vrtVungleManagerDelegate: self
        )

        if let error {
            VRTLogInfo("error: \(error)")
            let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
    }

    override func showInterstitialAd() {
        VRTLogInfo()
        guard let placementId else {
            VRTLogInfo("No placementId")
            let vrtError = VRTError(vrtErrorCode: .customEvent, message: "placementId nil")
            customEventShowDelegate?.customEventFailedToShow(
                vrtError: vrtError
            )
            return
        }
        
        guard let vc = viewControllerDelegate?.vrtViewControllerForModalPresentation() else {
            VRTLogInfo("No view controller")
            customEventShowDelegate?.customEventFailedToShow(
                vrtError: .customEventViewControllerNil
            )
            return
        }
        
        if let error = VRTVungleManager.singleton.showInterstitial(
            placementId: placementId,
            viewController: vc
        ) {
            VRTLogInfo("Failed to show")
            let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
            customEventShowDelegate?.customEventFailedToShow(
                vrtError: vrtError
            )
        }
    }

    // MARK: - VRTVungleManagerDelegate

    func vungleAdViewed(forPlacement placementID: String?) {
        customEventShowDelegate?.customEventShown()
    }

    func vungleDidCloseAd(forPlacementID placementID: String) {
        customEventShowDelegate?.customEventDidDismissModal(.unknown)
    }

    func vungleDidShowAd(forPlacementID placementID: String?) {
        customEventShowDelegate?.customEventShown()
    }

    func vungleRewardUser(forPlacementID placementID: String?) {
        // No VRT analog
    }

    func vungleTrackClick(forPlacementID placementID: String?) {
        customEventShowDelegate?.customEventClicked()
    }

    func vungleWillCloseAd(forPlacementID placementID: String) {
        customEventShowDelegate?.customEventWillDismissModal(.unknown)
    }

    func vungleWillLeaveApplication(forPlacementID placementID: String?) {
        customEventShowDelegate?.customEventWillLeaveApplication()
    }

    func vungleWillShowAd(forPlacementID placementID: String?) {
        // No VRT Analog
    }

    func vungleAdPlayabilityUpdate(_ isAdPlayable: Bool, placementID: String?, error: Error?) {
        VRTLogInfo("isAdPlayable: \(isAdPlayable), error: \(String(describing: error))")
        if let error {
            let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
            customEventLoadDelegate?.customEventFailedToLoad(
                vrtError: vrtError
            )
            return
        }

        if !isAdPlayable {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Vungle Ad Not Playable"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }

        customEventLoadDelegate?.customEventLoaded()
    }
}
