//
//  VRTVungleManagerDelegate.h
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 7/13/22.
//  Copyright © 2022 VRTCAL. All rights reserved.
//

@protocol VRTVungleManagerDelegate <NSObject>
- (void)vungleWillShowAdForPlacementID:(nullable NSString *)placementID;
- (void)vungleDidShowAdForPlacementID:(nullable NSString *)placementID;
- (void)vungleAdViewedForPlacement:(nullable NSString *)placementID;
- (void)vungleWillCloseAdForPlacementID:(nonnull NSString *)placementID;
- (void)vungleDidCloseAdForPlacementID:(nonnull NSString *)placementID;
- (void)vungleTrackClickForPlacementID:(nullable NSString *)placementID;
- (void)vungleWillLeaveApplicationForPlacementID:(nullable NSString *)placementID;
- (void)vungleRewardUserForPlacementID:(nullable NSString *)placementID;
- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(nullable NSString *)placementID error:(nullable NSError *)error;
@end
