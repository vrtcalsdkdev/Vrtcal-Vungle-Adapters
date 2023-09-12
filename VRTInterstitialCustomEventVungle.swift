//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
//
//  VRTBannerCustomEventGoogleMobileAds.h
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//
//  VRTInterstitialCustomEventGoogleMobileAds.m
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//Header
//Vungle Banner Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventVungle: VRTAbstractInterstitialCustomEvent, VRTVungleManagerDelegate {
    private var placementId: String?

    func loadInterstitialAd() {
        placementId = customEventConfig.thirdPartyCustomEventData["adUnitId"] as? String

        if placementId == nil {
            let error = VRTError(code: VRTErrorCodeCustomEvent, message: "No placement Id")
            customEventLoadDelegate.customEventFailedToLoadWithError(error)
            return
        }

        let error = VRTVungleManager.singleton().loadPlacement(
            withID: placementId ?? "",
            with: VungleAdSizeUnknown,
            vrtVungleManagerDelegate: self as? VRTVungleManagerDelegate)

        if let error {
            customEventLoadDelegate.customEventFailedToLoadWithError(error)
            return
        }
    }

    func showInterstitialAd() {
        let vc = viewControllerDelegate.vrtViewControllerForModalPresentation()
        VRTVungleManager.singleton().showInterstitial(placementId ?? "", viewController: vc)
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

        customEventLoadDelegate.customEventLoaded()
    }
}

//Dependencies