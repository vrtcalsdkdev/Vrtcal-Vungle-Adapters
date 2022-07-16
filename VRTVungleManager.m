//
//  VRTIronSourceManager.m
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Header
#import "VRTVungleManager.h"

//Dependencies
#import <VrtcalSDK/VrtcalSDK.h>
#import <VungleSDK/VungleSDK.h>

@interface VRTVungleManager() <VungleSDKDelegate>
@property VungleSDK *sdk;
@property(nonatomic) NSMapTable<NSString*, id<VRTVungleManagerDelegate>> *vrtVungleManagerDelegates;
@end

@implementation VRTVungleManager

+ (instancetype)singleton {
    static VRTVungleManager *singleton = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    self = [super init];

    self.sdk = [VungleSDK sharedSDK];
    self.sdk.delegate = self;
    
    //Init the map table such that it will not retain adapters referenced by it
    self.vrtVungleManagerDelegates = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    
    
    return self;
}

#pragma mark - API
-(NSError* _Nullable) loadPlacementWithID:(nonnull NSString *)placementID
                    withSize:(VungleAdSize)size
           vrtVungleManagerDelegate:(nonnull id <VRTVungleManagerDelegate>) vrtVungleManagerDelegate {
    

    [self addDelegate:vrtVungleManagerDelegate forPlacementID:placementID];

    
    NSError *error = nil;
    [self.sdk
        loadPlacementWithID:(NSString *)placementID
        withSize:(VungleAdSize)size
        error:&error
    ];
    
    return error;
}

-(nullable NSError*) showBanner:(nonnull NSString*)placementId inContainerView:(UIView*)containerView {
    NSError* error = nil;
    [self.sdk
        addAdViewToView:containerView
        withOptions:nil
        placementID:placementId
        error:&error
    ];
    
    return error;
}

- (nullable NSError*) showInterstitial:(NSString*)placementId viewController:(UIViewController*)viewController {
    NSError* error = nil;
    
    [self.sdk
        playAd:viewController
        options:nil
        placementID:placementId
        error:&error
    ];
    
    return error;
}


#pragma mark - Delegate Pass-Through
- (void)vungleWillShowAdForPlacementID:(nullable NSString *)placementID {
    [[self delegateForPlacementId:placementID] vungleWillShowAdForPlacementID:placementID];
}

- (void)vungleDidShowAdForPlacementID:(nullable NSString *)placementID {
    [[self delegateForPlacementId:placementID] vungleDidShowAdForPlacementID:placementID];
}

- (void)vungleAdViewedForPlacement:(NSString *)placementID {
    [[self delegateForPlacementId:placementID] vungleAdViewedForPlacement:placementID];
}

- (void)vungleWillCloseAdForPlacementID:(nonnull NSString *)placementID {
    [[self delegateForPlacementId:placementID] vungleWillCloseAdForPlacementID:placementID];
}

- (void)vungleDidCloseAdForPlacementID:(nonnull NSString *)placementID {
    [[self delegateForPlacementId:placementID] vungleDidCloseAdForPlacementID:placementID];
}

- (void)vungleTrackClickForPlacementID:(nullable NSString *)placementID {
    [[self delegateForPlacementId:placementID] vungleTrackClickForPlacementID:placementID];
}

- (void)vungleWillLeaveApplicationForPlacementID:(nullable NSString *)placementID {
    [[self delegateForPlacementId:placementID] vungleWillLeaveApplicationForPlacementID:placementID];
}

- (void)vungleRewardUserForPlacementID:(nullable NSString *)placementID {
    [[self delegateForPlacementId:placementID] vungleRewardUserForPlacementID:placementID];
}

- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(nullable NSString *)placementID error:(nullable NSError *)error {
    [[self delegateForPlacementId:placementID] vungleAdPlayabilityUpdate:isAdPlayable placementID:placementID error:error];
}


#pragma mark - NSMapTable Facade
- (void)addDelegate:(id<VRTVungleManagerDelegate>)vrtVungleManagerDelegate forPlacementID:(NSString *)placementId {
    @synchronized(self) {
        [self.vrtVungleManagerDelegates setObject:vrtVungleManagerDelegate forKey:placementId];
    }
}

- (id<VRTVungleManagerDelegate>) delegateForPlacementId:(NSString *)placementId {
    id<VRTVungleManagerDelegate> delegate;
    @synchronized(self) {
        delegate = [self.vrtVungleManagerDelegates objectForKey:placementId];
    }
    return delegate;
}

- (void)removeDelegateForPlacementId:(NSString *)placementId {
    @synchronized(self) {
        [self.vrtVungleManagerDelegates removeObjectForKey:placementId];
    }
}

@end
