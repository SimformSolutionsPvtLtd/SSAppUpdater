//
//  UIAlertController.swift
//  SSAppUpdater_Example
//
//  Created by Mansi Vadodariya on 26/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

// `UIAlertController` Extension for SSAppUpdator.
internal extension UIAlertController {
    
    /// - Parameters:
    ///   - title: Title of alert like "My Alert"
    ///   - message: what the purpose of alert
    ///   - actions: get input from user
    ///   - preferredStyle: Constants indicating the type of alert to display
    /// - Returns: An object that displays an alert message to the user
    static func showAlert(title: String?, message: String?, actions: [UIAlertAction], preferredStyle: UIAlertController.Style) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for action in actions {
            controller.addAction(action)
        }
        return controller
    }
}
