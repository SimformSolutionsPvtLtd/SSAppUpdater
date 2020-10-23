//
//  Bundle.swift
//  SSAppUpdater_Example
//
//  Created by Mansi Vadodariya on 26/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

extension Bundle {
    
    struct Constants {
        /// Constant for `CFBundleDisplayName`.
        static let displayName = "CFBundleDisplayName"
    }
    
    /// Get the name for the app to be displayed in the update alert.
    /// - Returns: The name of the app.
    class func getAppName() -> String {
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: Constants.displayName) as? String
        let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
        return bundleDisplayName ?? bundleName ?? ""
    }
    
}
