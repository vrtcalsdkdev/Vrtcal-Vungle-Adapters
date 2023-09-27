
//
//  VRTVungleManagerDelegate.swift
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 7/13/22.
//  Copyright © 2022 VRTCAL. All rights reserved.
//

import VungleSDK

protocol VRTVungleManagerDelegate: AnyObject {
    func vungleWillShowAd(forPlacementID placementID: String?)
    func vungleDidShowAd(forPlacementID placementID: String?)
    func vungleAdViewed(forPlacement placementID: String?)
    func vungleWillCloseAd(forPlacementID placementID: String)
    func vungleDidCloseAd(forPlacementID placementID: String)
    func vungleTrackClick(forPlacementID placementID: String?)
    func vungleWillLeaveApplication(forPlacementID placementID: String?)
    func vungleRewardUser(forPlacementID placementID: String?)
    func vungleAdPlayabilityUpdate(_ isAdPlayable: Bool, placementID: String?, error: Error?)
}
