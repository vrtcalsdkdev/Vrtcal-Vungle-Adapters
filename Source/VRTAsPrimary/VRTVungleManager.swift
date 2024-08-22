import VungleSDK
import VrtcalSDK

// Vungle Banner & Interstitial Adapter, Vrtcal as Primary
// The VungleSDK has only one delegate. This singleton handles interactions with it.
class VRTVungleManager {
    
    static let singleton = VRTVungleManager()
        
    private var vungleSdk: VungleSDK
    let vungleSDKDelegatePassthrough = VungleSDKDelegatePassthrough()
        
    init() {
        vungleSdk = VungleSDK.shared()
        vungleSdk.delegate = vungleSDKDelegatePassthrough
    }
    
    // MARK: - API
    
    func loadPlacement(
        withID placementID: String,
        with size: VungleAdSize,
        vrtVungleManagerDelegate: VRTVungleManagerDelegate
    ) -> Error? {
        VRTLogInfo()
        let vrtVungleManagerDelegateWeakRef = VRTVungleManagerDelegateWeakRef(
            vrtVungleManagerDelegate: vrtVungleManagerDelegate
        )
        
        vungleSDKDelegatePassthrough.delegates[placementID] = vrtVungleManagerDelegateWeakRef

        let result = Result {
            try vungleSdk.loadPlacement(
                withID: placementID,
                with: size
            )
        }
        
        return result.error
    }
    
    func showBanner(placementId: String, inContainerView containerView: UIView) -> Error? {
        VRTLogInfo()
        let result = Result {
            try vungleSdk.addAdView(
                to: containerView,
                withOptions: nil,
                placementID: placementId
            )
        }
        
        return result.error
    }
    
    func showInterstitial(placementId: String, viewController: UIViewController) -> Error? {
        VRTLogInfo()
        let result = Result {
            try vungleSdk.playAd(
                viewController,
                options: nil,
                placementID: placementId
            )
        }
        
        return result.error
    }
}

