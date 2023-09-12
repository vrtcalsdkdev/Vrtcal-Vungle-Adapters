//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
//
//  VRTBannerCustomEventGoogleMobileAds.h
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//
//  VRTBannerCustomEventGoogleMobileAds.m
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//Header
import VrtcalSDK

//Vungle Banner Adapter, Vrtcal as Primary

class VRTBannerCustomEventVungle: VRTAbstractBannerCustomEvent, VRTVungleManagerDelegate {
    private var containerView: UIView?

    func loadBannerAd() {
        let placementId = customEventConfig.thirdPartyCustomEventData["adUnitId"] as? String


        if placementId == nil {
            let error = VRTError(code: VRTErrorCodeCustomEvent, message: "No placement Id")
            customEventLoadDelegate.customEventFailedToLoadWithError(error)
            return
        }

        let frame = CGRect(
            x: 0,
            y: 0,
            width: customEventConfig.adSize.width,
            height: customEventConfig.adSize.height)

        //Must precede loadPlacementWithID as vungleAdPlayabilityUpdate is often called immediately
        containerView = UIView(frame: frame)

        let error = VRTVungleManager.singleton().loadPlacement(
            withID: placementId ?? "",
            with: VungleAdSizeBanner,
            vrtVungleManagerDelegate: self as? VRTVungleManagerDelegate)

        if let error {
            customEventLoadDelegate.customEventFailedToLoadWithError(error)
            return
        }




    }

    func getView() -> UIView? {
        return containerView
    }

    // MARK: - VRTVungleManagerDelegate

    func vungleAdViewed(forPlacement placementID: String?) {
        customEventShowDelegate.customEventShown()
    }

    func vungleDidCloseAd(forPlacementID placementID: String) {
        customEventShowDelegate.customEventDidDismissModal(VRTModalTypeUnknown)
    }

    func vungleDidShowAd(forPlacementID placementID: String?) {
        customEventShowDelegate.customEventShown()
    }

    func vungleRewardUser(forPlacementID placementID: String?) {
        // No VRT analog
    }

    func vungleTrackClick(forPlacementID placementID: String?) {
        customEventShowDelegate.customEventClicked()
    }

    func vungleWillCloseAd(forPlacementID placementID: String) {
        customEventShowDelegate.customEventWillDismissModal(VRTModalTypeUnknown)
    }

    func vungleWillLeaveApplication(forPlacementID placementID: String?) {
        customEventShowDelegate.customEventWillLeaveApplication()
    }

    func vungleWillShowAd(forPlacementID placementID: String?) {
        // No VRT Analog
    }

    func vungleAdPlayabilityUpdate(_ isAdPlayable: Bool, placementID: String?, error: Error?) {

        if let error {
            customEventLoadDelegate.customEventFailedToLoadWithError(error)
            return
        }

        if !isAdPlayable {
            let vrtError = VRTError(code: VRTErrorCodeNoFill, message: "Vungle Ad Not Playable")
            customEventLoadDelegate.customEventFailedToLoadWithError(vrtError)
            return
        }

        if let containerView {
            VRTVungleManager.singleton().showBanner(placementID ?? "", inContainerView: containerView)
        }
        customEventLoadDelegate.customEventLoaded()
    }
}

//Dependencies

//Vungle Banner Adapter, Vrtcal as Primary