//
//  PerformVersionCheck.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 21/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
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
        if SSAppUpdater.shared.showDefaultAlert {
            if !(version.elementsEqual(appStoreVersion)) {
                ///version are different
                if SSAppUpdater.shared.skipVersionAllow, let skipVersion = UserDefaults.skipVersion, skipVersion == appStoreVersion {
                    return
                } else {
                    if SSAppUpdater.shared.isForceUpdate {
                        DispatchQueue.main.async {
                            self.displayForceAlert(versionInfo: versionInfo)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.displayOptionalUpdateAlert(versionInfo: versionInfo)
                        }
                    }
                }
            }
        }
    }
    
    private func displayForceAlert(versionInfo: SSVersionInfo) {
        self.showAppUpdateAlert(versionInfo: versionInfo)
    }
    
    private func displayOptionalUpdateAlert(versionInfo: SSVersionInfo) {
        var showAlert = true
        if let date = UserDefaults.alertPresentationDate {
            switch SSAppUpdater.shared.updateAlertFrequency {
            case .always:
                showAlert = true
            case .daily:
                showAlert = Date().days(from: date) >= 1
            case .weekly:
                showAlert = Date().weeks(from: date) >= 1
            case .monthly:
                showAlert = Date().months(from: date) >= 1
            }
        }
        if showAlert {
            self.showAppUpdateAlert(versionInfo: versionInfo)
        }
    }
    
    private func showAppUpdateAlert(versionInfo: SSVersionInfo) {
        guard let releaseNote = versionInfo.appReleaseNote, let trackID = versionInfo.appID, let appStoreVersion = versionInfo.appVersion else {
            return
        }
        let window = UIApplication.shared.windows.first

        let ssViewController = SSViewController()
        ssViewController.currentWindow = window
        ssViewController.releaseNote = releaseNote
        ssViewController.trackID = trackID
        ssViewController.appStoreVersion = appStoreVersion
        ssViewController.modalPresentationStyle = .overFullScreen
        window?.rootViewController?.present(ssViewController, animated: false)
    }

    @available(iOS 13.0, *)
    private func getFirstWindowScene() -> UIWindowScene? {
        let connectedScenes = UIApplication.shared.connectedScenes
        if let windowActiveScene = connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            return windowActiveScene
        } else if let windowInactiveScene = connectedScenes.first(where: { $0.activationState == .foregroundInactive }) as? UIWindowScene {
            return windowInactiveScene
        } else {
            return nil
        }
    }
    
}
