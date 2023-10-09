//
//  VRTVungleManager.swift
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.

//Header
import Foundation
import UIKit
import VungleSDK

//Vungle Banner Adapter, Vrtcal as Primary
class VRTVungleManager {
    
    static let singleton = VRTVungleManager()
        
    private var vungleSdk: VungleSDK
    let vungleSDKDelegatePassthrough = VungleSDKDelegatePassthrough()
        
    init() {
        vungleSdk = VungleSDK.shared()
        vungleSdk.delegate = vungleSDKDelegatePassthrough
    }
    
    // MARK: - API
    
    func loadPlacement(
        withID placementID: String,
        with size: VungleAdSize,
        vrtVungleManagerDelegate: VRTVungleManagerDelegate
    ) -> Error? {
        
        let vrtVungleManagerDelegateWeakRef = VRTVungleManagerDelegateWeakRef(
            vrtVungleManagerDelegate: vrtVungleManagerDelegate
        )
        
        vungleSDKDelegatePassthrough.delegates[placementID] = vrtVungleManagerDelegateWeakRef

        let result = Result {
            try vungleSdk.loadPlacement(
                withID: placementID,
                with: size
            )
        }
        
        return result.getError()
    }
    
    func showBanner(placementId: String, inContainerView containerView: UIView) -> Error? {

        let result = Result {
            try vungleSdk.addAdView(
                to: containerView,
                withOptions: nil,
                placementID: placementId
            )
        }
        
        return result.getError()
    }
    
    func showInterstitial(placementId: String, viewController: UIViewController) -> Error? {

        let result = Result {
            try vungleSdk.playAd(
                viewController,
                options: nil,
                placementID: placementId
            )
        }
        
        return result.getError()
    }
}

