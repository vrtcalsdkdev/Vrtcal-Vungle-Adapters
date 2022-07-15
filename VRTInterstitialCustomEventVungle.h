//
//  VRTBannerCustomEventGoogleMobileAds.h
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

#import <VrtcalSDK/VrtcalSDK.h>
#import "VRTVungleManager.h"

//Vungle Banner Adapter, Vrtcal as Primary
@interface VRTInterstitialCustomEventVungle : VRTAbstractInterstitialCustomEvent <VRTVungleManagerDelegate>
@end
