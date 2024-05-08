//
//  VungleSDKDelegatePassthrough.swift
//  Vrtcal-Fyber-Marketplace-Adapters
//
//  Created by Scott McCoy on 9/16/23.
//

import VungleSDK
import VrtcalSDK

// Note: VungleSDKDelegate requires NSObject
class VungleSDKDelegatePassthrough: NSObject, VungleSDKDelegate {

    var delegates = [String: VRTVungleManagerDelegateWeakRef]()
    
    func vungleWillShowAd(forPlacementID placementID: String?) {
        VRTLogInfo("placementID: \(String(describing: placementID))")
        guard let placementID else {
            return
        }
        
        delegates[placementID]?.vrtVungleManagerDelegate?.vungleWillShowAd(
            forPlacementID: placementID
        )
    }

    func vungleDidShowAd(forPlacementID placementID: String?) {
        VRTLogInfo("placementID: \(String(describing: placementID))")
        guard let placementID else {
            return
        }

        delegates[placementID]?.vrtVungleManagerDelegate?.vungleDidShowAd(
            forPlacementID: placementID
        )
    }

    func vungleAdViewed(forPlacement placementID: String) {
        VRTLogInfo("placementID: \(placementID)")
        delegates[placementID]?.vrtVungleManagerDelegate?.vungleAdViewed(
            forPlacement: placementID
        )
    }

    func vungleWillCloseAd(forPlacementID placementID: String) {
        VRTLogInfo("placementID: \(placementID)")
        delegates[placementID]?.vrtVungleManagerDelegate?.vungleWillCloseAd(
            forPlacementID: placementID
        )
    }

    func vungleDidCloseAd(forPlacementID placementID: String) {
        VRTLogInfo("placementID: \(placementID)")
        delegates[placementID]?.vrtVungleManagerDelegate?.vungleDidCloseAd(
            forPlacementID: placementID
        )
    }

    func vungleTrackClick(forPlacementID placementID: String?) {
        VRTLogInfo("placementID: \(String(describing: placementID))")
        guard let placementID else {
            return
        }

        delegates[placementID]?.vrtVungleManagerDelegate?.vungleTrackClick(forPlacementID: placementID)
    }

    func vungleWillLeaveApplication(forPlacementID placementID: String?) {
        VRTLogInfo("placementID: \(String(describing: placementID))")
        guard let placementID else {
            return
        }

        delegates[placementID]?.vrtVungleManagerDelegate?.vungleWillLeaveApplication(forPlacementID: placementID)
    }

    func vungleRewardUser(forPlacementID placementID: String?) {
        VRTLogInfo("placementID: \(String(describing: placementID))")
        guard let placementID else {
            return
        }

        delegates[placementID]?.vrtVungleManagerDelegate?.vungleRewardUser(forPlacementID: placementID)
    }

    func vungleAdPlayabilityUpdate(_ isAdPlayable: Bool, placementID: String?, error: Error?) {
        VRTLogInfo("placementID: \(String(describing: placementID))")
        guard let placementID else {
            return
        }

        delegates[placementID]?.vrtVungleManagerDelegate?.vungleAdPlayabilityUpdate(
            isAdPlayable,
            placementID: placementID,
            error: error
        )
    }
}
