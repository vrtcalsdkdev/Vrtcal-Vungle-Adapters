//
//  VRTInterstitialCustomEventGoogleMobileAds.m
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//Header
#import "VRTInterstitialCustomEventVungle.h"

//Dependencies
#import "VRTVungleManager.h"


@interface VRTInterstitialCustomEventVungle()
@property NSString *placementId;
@end

@implementation VRTInterstitialCustomEventVungle

- (void) loadInterstitialAd {
    self.placementId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];
    
    if (self.placementId == nil) {
        VRTError *error = [VRTError errorWithCode:VRTErrorCodeCustomEvent message:@"No placement Id"];
        [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
        return;
    }
    
    NSError *error = [[VRTVungleManager singleton]
        loadPlacementWithID:self.placementId
        withSize:VungleAdSizeUnknown
        vrtVungleManagerDelegate:(id <VRTVungleManagerDelegate>) self
    ];
    
    if (error) {
        [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
        return;
    }
}

- (void) showInterstitialAd {
    UIViewController *vc = [self.viewControllerDelegate vrtViewControllerForModalPresentation];
    [[VRTVungleManager singleton] showInterstitial:self.placementId viewController:vc];
}


#pragma mark - VRTVungleManagerDelegate
- (void)vungleAdViewedForPlacement:(nullable NSString *)placementID {
    [self.customEventShowDelegate customEventShown];
}

- (void)vungleDidCloseAdForPlacementID:(nonnull NSString *)placementID {
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeUnknown];
}

- (void)vungleDidShowAdForPlacementID:(nullable NSString *)placementID {
    [self.customEventShowDelegate customEventShown];
}

- (void)vungleRewardUserForPlacementID:(nullable NSString *)placementID {
    // No VRT analog
}

- (void)vungleTrackClickForPlacementID:(nullable NSString *)placementID {
    [self.customEventShowDelegate customEventClicked];
}

- (void)vungleWillCloseAdForPlacementID:(nonnull NSString *)placementID {
    [self.customEventShowDelegate customEventWillDismissModal:VRTModalTypeUnknown];
}

 - (void)vungleWillLeaveApplicationForPlacementID:(nullable NSString *)placementID {
    [self.customEventShowDelegate customEventWillLeaveApplication];
}

- (void)vungleWillShowAdForPlacementID:(nullable NSString *)placementID {
    // No VRT Analog
}

- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(nullable NSString *)placementID error:(nullable NSError *)error {
    
    if (error) {
        [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
        return;
    }
    
    if (!isAdPlayable) {
        VRTError *vrtError = [VRTError errorWithCode:VRTErrorCodeNoFill message:@"Vungle Ad Not Playable"];
        [self.customEventLoadDelegate customEventFailedToLoadWithError:vrtError];
        return;
    }
    
    [self.customEventLoadDelegate customEventLoaded];
}
@end
