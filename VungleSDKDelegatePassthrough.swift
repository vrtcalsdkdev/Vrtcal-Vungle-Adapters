//
//  VungleSDKDelegatePassthrough.swift
//  Vrtcal-Fyber-Marketplace-Adapters
//
//  Created by Scott McCoy on 9/16/23.
//

import VungleSDK

class VungleSDKDelegatePassthrough: NSObject, VungleSDKDelegate {

    var delegates = [String: VRTVungleManagerDelegateWeakRef]()
    
    func vungleWillShowAd(forPlacementID placementID: String?) {
        if let placementID {
            delegates[placementID]?.vrtVungleManagerDelegate?.vungleWillShowAd(forPlacementID: placementID)
        }
    }

    func vungleDidShowAd(forPlacementID placementID: String?) {
        if let placementID {
            delegates[placementID]?.vrtVungleManagerDelegate?.vungleDidShowAd(forPlacementID: placementID)
        }
    }

    func vungleAdViewed(forPlacement placementID: String) {
        delegates[placementID]?.vrtVungleManagerDelegate?.vungleAdViewed(forPlacement: placementID)
    }

    func vungleWillCloseAd(forPlacementID placementID: String) {
        delegates[placementID]?.vrtVungleManagerDelegate?.vungleWillCloseAd(forPlacementID: placementID)
    }

    func vungleDidCloseAd(forPlacementID placementID: String) {
        delegates[placementID]?.vrtVungleManagerDelegate?.vungleDidCloseAd(forPlacementID: placementID)
    }

    func vungleTrackClick(forPlacementID placementID: String?) {
        if let placementID {
            delegates[placementID]?.vrtVungleManagerDelegate?.vungleTrackClick(forPlacementID: placementID)
        }
    }

    func vungleWillLeaveApplication(forPlacementID placementID: String?) {
        if let placementID {
            delegates[placementID]?.vrtVungleManagerDelegate?.vungleWillLeaveApplication(forPlacementID: placementID)
        }
    }

    func vungleRewardUser(forPlacementID placementID: String?) {
        if let placementID {
            delegates[placementID]?.vrtVungleManagerDelegate?.vungleRewardUser(forPlacementID: placementID)
        }
    }

    func vungleAdPlayabilityUpdate(_ isAdPlayable: Bool, placementID: String?, error: Error?) {
        if let placementID {
            delegates[placementID]?.vrtVungleManagerDelegate?.vungleAdPlayabilityUpdate(isAdPlayable, placementID: placementID, error: error)
        }
    }
}
