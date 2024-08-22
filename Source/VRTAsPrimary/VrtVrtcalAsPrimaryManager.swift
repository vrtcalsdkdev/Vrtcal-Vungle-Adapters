import VrtcalSDK
import VungleSDK

// Must be NSObject for VungleSDKDelegate
class VRTAsPrimaryManager: NSObject {

    static var singleton = VRTAsPrimaryManager()
    var initialized = false
    var completionHandler: ((Result<Void,VRTError>) -> ())?
    
    func initializeThirdParty(
        customEventConfig: VRTCustomEventConfig,
        completionHandler: @escaping (Result<Void,VRTError>) -> ()
    ) {
        // Require the appId
        guard let appId = customEventConfig.thirdPartyCustomEventDataValue(
            thirdPartyCustomEventKey: .appId
        ).getSuccess(failureHandler: { vrtError in
            completionHandler(.failure(vrtError))
        }) else {
            return
        }
        
        self.completionHandler = completionHandler

        do {
            VungleSDK.shared().delegate = self
            // Note: This is TwitMore's appId
            // https://publisher.vungle.com/applications/update/application/627c5502a9cf1e63b8e6137d
            try VungleSDK.shared().start(withAppId: appId)
        } catch {
            let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
            completionHandler(.failure(vrtError))
        }
    }
}

extension VRTAsPrimaryManager: VungleSDKDelegate {
    func vungleSDKDidInitialize() {
        initialized = true
        completionHandler?(.success())
        completionHandler = nil
    }
    
    func vungleSDKFailedToInitializeWithError(_ error: Error) {
        let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
        completionHandler?(.failure(vrtError))
        completionHandler = nil
    }
}

