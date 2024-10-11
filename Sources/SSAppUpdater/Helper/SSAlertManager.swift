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

// MARK: - SSAlertManagerConstants
extension SSAlertManager {
    struct SSAlertManagerConstants {
        static let nsAlertPanel = "_NSAlertPanel"
    }
}

// MARK: - Show alert
extension SSAlertManager {
    /**
     Displays an alert dialog with a title, subtitle, and up to three buttons for both iOS and macOS platforms.

     - Parameters:
        - alertIcon: A `String` representing the icon to display in the alert. On iOS, this parameter is currently unused. On macOS, the icon is displayed using `NSImage(systemSymbolName:accessibilityDescription:)`.
        - title: A `String` representing the title of the alert.
        - subTitle: A `String` representing the message or subtitle of the alert.
        - primaryButtonTitle: A `String` representing the title of the primary action button (e.g., "OK", "Confirm").
        - primaryButtonAction: An optional closure `(() -> Void)?` that is executed when the primary button is pressed. Defaults to `nil` if no action is needed.
        - secondaryButtonTitle: An optional `String` representing the title of the secondary button. If `nil`, the secondary button is not shown.
        - secondaryButtonAction: An optional closure `(() -> Void)?` that is executed when the secondary button is pressed. Defaults to `nil` if no action is needed.
        - cancelButtonTitle: An optional `String` representing the title of the cancel button. If `nil`, the cancel button is not shown.
        - cancelButtonAction: An optional closure `(() -> Void)?` that is executed when the cancel button is pressed. Defaults to `nil` if no action is needed.

     The behavior of the alert depends on the platform:

     - **iOS**: Uses `UIAlertController` to present the alert. Buttons are created based on the provided titles and actions.
     - **macOS**: Uses `NSAlert` to present the alert. The `alertIcon` is displayed (if valid) and buttons are created for each action.
    */
    func showAlert(
        alertIcon: String,
        title: String,
        subTitle: String,
        primaryButtonTitle: String,
        primaryButtonAction: (() -> Void)? = nil,
        secondaryButtonTitle: String? = nil,
        secondaryButtonAction: (() -> Void)? = nil,
        cancelButtonTitle: String? = nil,
        cancelButtonAction: (() -> Void)? = nil
    ) {
        #if os(iOS)
            let alert = UIAlertController(
                title: title,
                message: subTitle,
                preferredStyle: .alert
            )
            
            alert.addAction(
                UIAlertAction(
                    title: primaryButtonTitle,
                    style: .default) { _ in
                        if let primaryButtonAction {
                            primaryButtonAction()
                        }
                    }
            )
            
            if let secondaryButtonTitle {
                alert.addAction(
                    UIAlertAction(
                        title: secondaryButtonTitle,
                        style: .default) { _ in
                            if let secondaryButtonAction {
                                secondaryButtonAction()
                            }
                        }
                )
            }
            
            if let cancelButtonTitle {
                alert.addAction(
                    UIAlertAction(
                        title: cancelButtonTitle,
                        style: .default) { _ in
                            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                            if let cancelButtonAction {
                                cancelButtonAction()
                            }
                        }
                )
            }
            
            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                return
            }
            rootViewController.present(alert, animated: true, completion: nil)
        #else
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = subTitle
            alert.alertStyle = .informational
            alert.addButton(withTitle: primaryButtonTitle)
            if let iconImage = NSImage(systemSymbolName: alertIcon, accessibilityDescription: nil) {
                alert.icon = iconImage
            }
            if let secondaryButtonTitle {
                alert.addButton(withTitle: secondaryButtonTitle)
            }

            if let cancelButtonTitle {
                alert.addButton(withTitle: cancelButtonTitle)
            }

            guard let mainWindow = NSApplication.shared.keyWindow else {
                return
            }
            alert.beginSheetModal(for: mainWindow) { (response) in
                if response == .alertFirstButtonReturn, let primaryButtonAction {
                    primaryButtonAction()
                } else if response == .alertSecondButtonReturn, let secondaryButtonAction {
                    secondaryButtonAction()
                } else if let cancelButtonAction {
                    cancelButtonAction()
                }
                alert.window.close()
            }
        #endif
    }
}
