//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
//
//  VRTVungleManager.swift
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//
//
//  VRTIronSourceManager.m
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Header
import Foundation
import UIKit
import VungleSDK

class VRTVungleManager: NSObject, VungleSDKDelegate {
    private var sdk: VungleSDK?
    private var vrtVungleManagerDelegates: NSMapTable<String, VRTVungleManagerDelegate?>?

    static let singletonVar = self.init()

    class func singleton() -> Self {

        // [Swiftify] `dispatch_once()` call was converted to the initializer of the `singletonVar` variable
        return singletonVar
    }

    override init() {
        super.init()

        sdk = .shared()
        sdk?.delegate = self

        //Init the map table such that it will not retain adapters referenced by it
        vrtVungleManagerDelegates = NSMapTable(keyOptions: .strongMemory, valueOptions: .weakMemory)


    }

    // MARK: - API

    func loadPlacement(
        withID placementID: String,
        with size: VungleAdSize,
        vrtVungleManagerDelegate: VRTVungleManagerDelegate
    ) -> Error? {


        add(vrtVungleManagerDelegate, forPlacementID: placementID)


        var error: Error?
        sdk?.loadPlacement(
            withID: placementID,
            with: size,
            error: &error)

        return error
    }

    func showBanner(_ placementId: String, inContainerView containerView: UIView) -> Error? {
        var error: Error?
        sdk?.addAdView(
            to: containerView,
            withOptions: nil,
            placementID: placementId,
            error: &error)

        return error
    }

    func showInterstitial(_ placementId: String, viewController: UIViewController) -> Error? {
        var error: Error?

        sdk?.playAd(
            viewController,
            options: nil,
            placementID: placementId,
            error: &error)

        return error
    }

    // MARK: - Delegate Pass-Through

    func vungleWillShowAd(forPlacementID placementID: String?) {
        delegate(forPlacementId: placementID)?.vungleWillShowAd(forPlacementID: placementID)
    }

    func vungleDidShowAd(forPlacementID placementID: String?) {
        delegate(forPlacementId: placementID)?.vungleDidShowAd(forPlacementID: placementID)
    }

    func vungleAdViewed(forPlacement placementID: String?) {
        delegate(forPlacementId: placementID)?.vungleAdViewed(forPlacement: placementID)
    }

    func vungleWillCloseAd(forPlacementID placementID: String) {
        delegate(forPlacementId: placementID)?.vungleWillCloseAd(forPlacementID: placementID)
    }

    func vungleDidCloseAd(forPlacementID placementID: String) {
        delegate(forPlacementId: placementID)?.vungleDidCloseAd(forPlacementID: placementID)
    }

    func vungleTrackClick(forPlacementID placementID: String?) {
        delegate(forPlacementId: placementID)?.vungleTrackClick(forPlacementID: placementID)
    }

    func vungleWillLeaveApplication(forPlacementID placementID: String?) {
        delegate(forPlacementId: placementID)?.vungleWillLeaveApplication(forPlacementID: placementID)
    }

    func vungleRewardUser(forPlacementID placementID: String?) {
        delegate(forPlacementId: placementID)?.vungleRewardUser(forPlacementID: placementID)
    }

    func vungleAdPlayabilityUpdate(_ isAdPlayable: Bool, placementID: String?, error: Error?) {
        delegate(forPlacementId: placementID)?.vungleAdPlayabilityUpdate(isAdPlayable, placementID: placementID, error: error)
    }

    // MARK: - NSMapTable Facade

    func add(_ vrtVungleManagerDelegate: VRTVungleManagerDelegate?, forPlacementID placementId: String?) {
        objc_sync_enter(self)
        vrtVungleManagerDelegates?.set(vrtVungleManagerDelegate, forKey: placementId ?? "")
        objc_sync_exit(self)
    }

    func delegate(forPlacementId placementId: String?) -> VRTVungleManagerDelegate? {
        var delegate: VRTVungleManagerDelegate?
        objc_sync_enter(self)
        delegate = vrtVungleManagerDelegates?[placementId ?? ""] as? VRTVungleManagerDelegate
        objc_sync_exit(self)
        return delegate
    }

    func removeDelegate(forPlacementId placementId: String?) {
        objc_sync_enter(self)
        vrtVungleManagerDelegates?.removeObject(forKey: placementId)
        objc_sync_exit(self)
    }
}

//Dependencies