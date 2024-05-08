//
//  AlertView.swift
//  Pods-SSAppUpdater_Example
//
//  Created by Rishita Panchal on 10/04/24.
//

import StoreKit

internal class SSAlertManager {
    // MARK: - Variables
    static let shared = SSAlertManager()
}

// MARK: - Constants
extension SSAlertManager {
    struct AlertManagerConstants {
        static let update = "Update"
        static let cancel = "Cancel"
        static let skipThisVersion = "Skip this version"
        static let nsAlertPanel = "_NSAlertPanel"
    }
}

// MARK: - Show alert
extension SSAlertManager {
    /**
    Displays an alert for updating the application with detailed update information. It handles both mandatory and optional updates.

    - Parameters:
      - versionInfo: Information about the current version.
      - releaseNote: Release notes for the update.
      - trackID: Identifier for tracking purposes.
      - isForceUpdate: A Boolean value indicating whether the update is mandatory.
      - appStoreVersion: The version of the application available in the App Store.
      - dismissParentViewController: Closure to dismiss the parent view controller.
      - primaryButtonAction: Closure representing the action of the primary button.

    - Platform Specifics:
      - iOS: Uses UIAlertController for displaying the alert.
      - macOS: Uses NSAlert for displaying the alert.
     **/

    func showAlert(
        releaseNote: String,
        isForceUpdate: Bool,
        appStoreVersion: String,
        skipVersionAllow: Bool,
        dismissParentViewController: @escaping (() -> Void),
        primaryButtonAction: @escaping (() -> Void)
    ) {
        #if os(iOS)
            let alert = UIAlertController(
                title: Bundle.getAppName(),
                message: "\n A new version \(appStoreVersion) \n\n \(releaseNote)",
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: AlertManagerConstants.update,
                    style: .default) { _ in
                        primaryButtonAction()
                    }
            )

            if skipVersionAllow {
                alert.addAction(
                    UIAlertAction(
                        title: AlertManagerConstants.skipThisVersion,
                        style: .default) { _ in
                            UserDefaults.skipVersion = appStoreVersion
                        }
                )
            }
        
            if !isForceUpdate {
                alert.addAction(
                    UIAlertAction(
                        title: AlertManagerConstants.cancel,
                        style: .default) { _ in
                            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                            dismissParentViewController()
                        }
                )
            }

            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                return
            }
            rootViewController.present(alert, animated: true, completion: nil)
        #else
            let presentedAlertWindows = NSApplication.shared.windows.filter {
                $0.className == AlertManagerConstants.nsAlertPanel
            }
            if presentedAlertWindows.isEmpty {
                let alert = NSAlert()
                alert.messageText = Bundle.getAppName()
                alert.informativeText = "\n A new version \(appStoreVersion) \n\n \(releaseNote)"
                alert.alertStyle = .informational
                alert.addButton(withTitle: AlertManagerConstants.update)
                if let iconImage = NSImage(systemSymbolName: "exclamationmark.arrow.triangle.2.circlepath", accessibilityDescription: nil) {
                    alert.icon = iconImage
                }
                if skipVersionAllow {
                    alert.addButton(withTitle: AlertManagerConstants.skipThisVersion)
                }

                if !isForceUpdate {
                    alert.addButton(withTitle: AlertManagerConstants.cancel)
                }

                guard let mainWindow = NSApplication.shared.mainWindow else { return }
                alert.beginSheetModal(for: mainWindow) { (response) in
                    if response == .alertFirstButtonReturn {
                        primaryButtonAction()
                    } else if response == .alertSecondButtonReturn && skipVersionAllow {
                        UserDefaults.skipVersion = appStoreVersion
                    } else {
                        dismissParentViewController()
                    }
                    alert.window.close()
                }
            }
        #endif
    }
}
