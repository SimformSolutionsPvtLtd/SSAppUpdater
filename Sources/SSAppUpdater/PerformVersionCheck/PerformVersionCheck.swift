//
//  PerformVersionCheck.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 21/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import StoreKit
import SwiftUI
import Combine

internal class PerformVersionCheck: NSObject, SKStoreProductViewControllerDelegate {

    // MARK: - Variables
    var completion: (SSVersionInfo) -> Void?
    var networkManager = SSNetworkManager()

    // MARK: - Initialisers
    init(isManualMacOSUpdate: Bool, completion: @escaping (SSVersionInfo) -> Void) {
        self.completion = completion
        super.init()
        if isManualMacOSUpdate {
            #if os(macOS)
            processManualVersionCheck(from: SSAppUpdater.shared.serverURL)
            #endif
        } else {
            #if os(iOS)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(getVersionCheck),
                name: UIApplication.willResignActiveNotification,
                object: nil
            )
            #endif
            DispatchQueue.main.async {
                self.getVersionCheck()
            }
        }
    }
}

// MARK: - Constants
extension PerformVersionCheck {
    struct  PerformVersionCheckConstants {
        static let done = "Done"
        static let baseAppStoreUrl = "itms-apps://itunes.apple.com/app/id"

        static let updateSystemImage = "exclamationmark.arrow.triangle.2.circlepath"
        static let warningSystemImage = "exclamationmark.triangle.fill"
        static let update = "Update"
        static let cancel = "Cancel"
        static let ok = "OK"
        static let manualMacAppUpdateErrorTitle = "Something went wrong!!"
        static let skipThisVersion = "Skip this version"

        static let noInternetAlertTitle = "No internet"
        static let noInternetAlertSubTitle = "Please check your internet and  try again"

        static let versionTag = "version"
        static let latestBuildURLTag = "latestBuildURL"
        static let applicationDir = "/Applications/"
    }
}

// MARK: - Perform version check
extension PerformVersionCheck {
    /**
        This function querying the iTunes Search API to retrieve information about the latest version of the application available on the App Store.
     */
    @objc func getVersionCheck() {
        SSAPIManager.shared.getLookUpData { (result, error) in
            guard let appStoreVersion = result?.results?.first?.version else {
                return
            }
            self.performVersionCheck(
                appStoreVersion: appStoreVersion,
                result: result
            )
        }
    }

    /**
        Performs a version check to determine if there's a new version of the application available on the App Store, and handles the update process accordingly.

        - Parameters:
            - appStoreVersion: The version string of the latest available version on the App Store.
            - result: An optional `LookUpResponseModel` object containing information retrieved from the App Store lookup API.
    */
    private func performVersionCheck(appStoreVersion: String, result: LookUpResponseModel?) {
        guard let version = Bundle.version() else { return }
        if let minOSVersion = result?.results?.first?.minimumOsVersion {
            #if os(iOS)
            let currentOSVersion = UIDevice.current.systemVersion
            #else
            let currentOSVersion = "\(ProcessInfo.processInfo.operatingSystemVersion.majorVersion)"
            #endif

            if minOSVersion.compare(
                currentOSVersion, options: .numeric
            ) == .orderedDescending {
                print("Skip Version Check as New OS Version is not supported by the Current OS Version")
                completion(
                    SSVersionInfo(
                        isAppUpdateAvailable: false,
                        appReleaseNote: "",
                        appVersion: "",
                        appID: nil,
                        appURL: ""
                    )
                )
                return
            }
        }
        let isNewVersionAvailable = self.isAppStoreVersionAvailable(
            version: version,
            appStoreVersion: appStoreVersion
        )
        let versionInfo = SSVersionInfo(
            isAppUpdateAvailable: isNewVersionAvailable,
            appReleaseNote: result?.results?.first?.releaseNotes,
            appVersion: appStoreVersion,
            appID: result?.results?.first?.trackId,
            appURL: result?.results?.first?.trackViewUrl
        )
        if SSAppUpdater.shared.showDefaultAlert {
            if isNewVersionAvailable {
                if SSAppUpdater.shared.skipVersionAllow,
                   let skipVersion = UserDefaults.skipVersion,
                   skipVersion == appStoreVersion {
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
            } else {
                UserDefaults.alertPresentationDate = nil
            }
        } else {
            completion(versionInfo)
        }
    }

    /**
        Determines if a newer version of the application is available on the App Store compared to the current installed version.

        - Parameters:
            - version: The version string of the current installed version of the application.
            - appStoreVersion: The version string of the latest available version on the App Store.
    */
    private func isAppStoreVersionAvailable(version: String, appStoreVersion: String) -> Bool {
        return version.compare(appStoreVersion, options: .numeric) == .orderedAscending
    }
}

// MARK: - Display alert functions
extension PerformVersionCheck {
    /**
        Displays an alert to prompt the user to update the application to the latest available version.

        - Parameters:
            - versionInfo: An `SSVersionInfo` object containing details about the available app update, including release notes, app ID, and app version.
    */
    private func showAppUpdateAlert(versionInfo: SSVersionInfo) {
        guard let releaseNote = versionInfo.appReleaseNote,
              let trackID = versionInfo.appID,
              let appStoreVersion = versionInfo.appVersion else
        { return }
        SSAlertManager.shared.showAlert(
            alertIcon: PerformVersionCheckConstants.updateSystemImage,
            title: Bundle.getAppName(),
            subTitle: "\n A new version \(appStoreVersion) \n\n \(releaseNote)",
            primaryButtonTitle: PerformVersionCheckConstants.update,
            primaryButtonAction: {
                #if os(iOS)
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                #endif
                self.launchAppUpdate(trackId: trackID)
            },
            secondaryButtonTitle: SSAppUpdater.shared.skipVersionAllow ? PerformVersionCheckConstants.skipThisVersion : nil,
            secondaryButtonAction: {
                UserDefaults.skipVersion = appStoreVersion
            },
            cancelButtonTitle: SSAppUpdater.shared.isForceUpdate ? nil : PerformVersionCheckConstants.cancel,
            cancelButtonAction: { }
        )
    }

    /** 
        This function displays a force alert
     */
    func displayForceAlert(versionInfo: SSVersionInfo) {
        self.showAppUpdateAlert(versionInfo: versionInfo)
    }

    /**
        This function displays a optional update alert
     */
    private func displayOptionalUpdateAlert(versionInfo: SSVersionInfo) {
        var showAlert = true
        if let date = UserDefaults.alertPresentationDate,
           let lastAlertPresentedDate = date.formatDate() {
            switch SSAppUpdater.shared.updateAlertFrequency {
            case .always:
                showAlert = true
            case .daily:
                showAlert = Date().days(from: lastAlertPresentedDate) >= 1
            case .weekly:
                showAlert = Date().weeks(from: lastAlertPresentedDate) >= 1
            case .monthly:
                showAlert = Date().months(from: lastAlertPresentedDate) >= 1
            }
        }
        if showAlert {
            UserDefaults.alertPresentationDate = "\(Date())"
            self.showAppUpdateAlert(versionInfo: versionInfo)
        }
    }
}

extension PerformVersionCheck {
    #if os(iOS)
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true)
        if SSAppUpdater.shared.isForceUpdate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.getVersionCheck()
            }
        }
    }
    #endif
}

// MARK: - Launch product in appstore
extension PerformVersionCheck {
    /**
        This function launches the the product page of the specified app for updating or viewing details for iOS and macOS both.

        - Parameters:
            - trackId: The unique identifier of the app on the App Store or Mac App Store.
     */
    private func launchAppUpdate(trackId: Int) {
        if networkManager.isConnected {
        #if os(iOS)
            if SSAppUpdater.shared.redirectToAppStore {
                if let appStoreURL = URL(string: "\(PerformVersionCheckConstants.baseAppStoreUrl)\(trackId)") {
                    UIApplication.shared.open(appStoreURL)
                }
                return
            }
            let storeViewController = SKStoreProductViewController()
            storeViewController.delegate = self
            let parametersDictionary = [SKStoreProductParameterITunesItemIdentifier: trackId]

            storeViewController.loadProduct(withParameters: parametersDictionary) { _, error in
                if error != nil {
                    if let appStoreURL = URL(string: "\(PerformVersionCheckConstants.baseAppStoreUrl)\(trackId)") {
                        UIApplication.shared.open(appStoreURL)
                    }
                } else {
                    let scene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive }
                    if let windowScene = scene as? UIWindowScene {
                        if #available(iOS 15.0, *) {
                            windowScene.keyWindow?.rootViewController?.present(storeViewController, animated: true, completion: nil)
                        } else {
                            if let window = windowScene.windows.first {
                                if let rootViewController = window.rootViewController {
                                    rootViewController.present(storeViewController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        #else
        if SSAppUpdater.shared.redirectToAppStore {
            AppStoreView(trackId: trackId).goToAppStoreApplication()
        } else {
            guard let mainWindow = NSApplication.shared.windows.first else { return }
            if let screen = mainWindow.screen ?? NSScreen.main {
                mainWindow.setFrame(screen.visibleFrame, display: true)
            }
            let containerView = VStack(alignment: .leading) {
                updateButton(for: mainWindow)
                AppStoreView(trackId: Int(trackId))
                    .frame(
                        width: mainWindow.frame.size.width,
                        height: mainWindow.frame.size.height
                    )
            }
            let viewController = NSHostingController(rootView: containerView)
            mainWindow.contentViewController?.presentAsSheet(viewController)
        }
        #endif
        } else {
            SSAlertManager.shared.showAlert(
                alertIcon: PerformVersionCheckConstants.warningSystemImage,
                title: PerformVersionCheckConstants.noInternetAlertTitle,
                subTitle: PerformVersionCheckConstants.noInternetAlertSubTitle,
                primaryButtonTitle: PerformVersionCheckConstants.ok,
                primaryButtonAction: {
                    self.getVersionCheck()
                }
            )
        }
    }

    #if os(macOS)
    /**
        Creates a dismiss button for use within a macOS window, allowing users to dismiss a presented sheet modal.

        - Parameters:
            - mainWindow: The main window instance from which the sheet modal is presented.
    */
    func updateButton(for mainWindow: NSWindow) -> some View {
        Button(action: {

            if let attachedSheet = mainWindow.attachedSheet {
                mainWindow.endSheet(attachedSheet)
            }
            if SSAppUpdater.shared.isForceUpdate {
                self.getVersionCheck()
            }
        }, label: {
            Text(PerformVersionCheckConstants.done)
                .font(.body)
                .padding(.top, 5)
        })
        .padding([.leading, .top], 15)
        .buttonStyle(.plain)
    }
    #endif
}
