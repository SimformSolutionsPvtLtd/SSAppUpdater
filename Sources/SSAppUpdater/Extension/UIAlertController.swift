//
//  UIAlertController.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 21/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

// `UIAlertController` Extension for SSAppUpdator.
extension UIAlertController {
    /// Presents SSAppUpdator's `UIAlertController` in a new `UIWindow`.
    ///
    /// - Parameter window: The `UIWindow` that _should_ reference SSAppUpdator's `UIAlertController`.
    func show(window: UIWindow) {
        guard !self.isBeingPresented else { return }
        window.makeKeyAndVisible()
        window.rootViewController?.present(self, animated: true, completion: nil)
    }

    /// Hides SSAppUpdator's `UIAlertController` within a given window.
    ///
    /// - Parameter window: The `UIWindow` that references SSAppUpdator's `UIAlertController`.
    func hide(window: UIWindow) {
        window.isHidden = true
    }
    
    /// - Parameters:
    ///   - title: Title of alert like "My Alert"
    ///   - message: what the purpose of alert
    ///   - actions: get input from user
    ///   - preferredStyle: Constants indicating the type of alert to display
    /// - Returns: An object that displays an alert message to the user
    static public func showAlert(title: String?, message: String?, actions: [UIAlertAction], preferredStyle: UIAlertController.Style) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for action in actions {
            controller.addAction(action)
        }
        return controller
    }
}
