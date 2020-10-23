//
//  PerformVersionCheck.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 21/10/20.
//  Copyright © 2020 Mansi Vadodariya. All rights reserved.
//

import UIKit
import StoreKit

internal class PerformVersionCheck {
    
    // MARK: - Variable Declaration
    private var completion: (SSVersionInfo) -> Void?
    
    // MARK: - Initializers
    init(completion: @escaping (SSVersionInfo) -> Void) {
        self.completion = completion
        // Observer to perform version check when app will EnterForeground
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getVersionCheck),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
        getVersionCheck()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
     // MARK: - Functions
    /// this function is used for version check through itunesSearchAPI.
    @objc private func getVersionCheck() {
        SSAPIManager.shared.getLookUpData { (result, error) in
            guard let appStoreVersion = result?.results?.first?.version else {
                return
            }
            self.perforAppCheck(appStoreVersion: appStoreVersion, result: result)
        }
    }
    
    private func perforAppCheck(appStoreVersion: String, result: LookUpResponseModel?) {
        guard let version = Bundle.version() else {
            return
        }
        if let minOSVersion = result?.results?.first?.minimumOsVersion {
            let currenOSVersion = UIDevice.current.systemVersion
            if minOSVersion.compare(currenOSVersion, options: .numeric) == .orderedDescending {
                print("Skip Version Check as New OS Version is not supported by the Current OS Version")
                completion( SSVersionInfo(isAppUpdateAvailable: false, appReleaseNote: "", appVersion: "", appID: nil, appURL: ""))
                return
            }
        }
        let versionInfo = SSVersionInfo(isAppUpdateAvailable: !version.elementsEqual(appStoreVersion), appReleaseNote: result?.results?.first?.releaseNotes, appVersion: appStoreVersion, appID: result?.results?.first?.trackId, appURL: result?.results?.first?.trackViewUrl)
        completion(versionInfo)
    }
    
}
