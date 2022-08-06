//
//  VRTBannerCustomEventGoogleMobileAds.m
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//Header
#import "VRTBannerCustomEventVungle.h"

//Dependencies
#import "VRTVungleManager.h"

@interface VRTBannerCustomEventVungle()
@property UIView* containerView;
@end


//Vungle Banner Adapter, Vrtcal as Primary
@implementation VRTBannerCustomEventVungle

- (void) loadBannerAd {
    NSString *placementId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];

    
    if (placementId == nil) {
        VRTError *error = [VRTError errorWithCode:VRTErrorCodeCustomEvent message:@"No placement Id"];
        [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
        return;
    }
    
    CGRect frame = CGRectMake(
        0,
        0,
        self.customEventConfig.adSize.width,
        self.customEventConfig.adSize.height
    );
    
    //Must precede loadPlacementWithID as vungleAdPlayabilityUpdate is often called immediately
    self.containerView = [[UIView alloc] initWithFrame:frame];
    
    NSError *error = [[VRTVungleManager singleton]
        loadPlacementWithID:placementId
        withSize:VungleAdSizeBanner
        vrtVungleManagerDelegate:(id <VRTVungleManagerDelegate>) self
    ];
    
    if (error) {
        [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
        return;
    }
    
    
}

- (UIView*) getView {
    return self.containerView;
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
    
    [[VRTVungleManager singleton] showBanner:placementID inContainerView:self.containerView];
    [self.customEventLoadDelegate customEventLoaded];
}
@end
