//
//  VRTVungleManager.h
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <VungleSDK/VungleSDK.h>
#import <UIKit/UIKit.h>
#import "VRTVungleManagerDelegate.h"


@interface VRTVungleManager : NSObject
+ (instancetype _Nonnull )singleton;

-(NSError* _Nullable) loadPlacementWithID:(nonnull NSString *)placementID
                                 withSize:(VungleAdSize)size
                 vrtVungleManagerDelegate:(nonnull id <VRTVungleManagerDelegate>) vrtVungleManagerDelegate;

-(nullable NSError*) showBanner:(nonnull NSString*)placementId inContainerView:(nonnull UIView*)containerView;
-(nullable NSError*) showInterstitial:(nonnull NSString*)placementId viewController:(nonnull UIViewController*)viewController;

@end
