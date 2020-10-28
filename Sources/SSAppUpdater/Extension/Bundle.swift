//
//  Bundle.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 21/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import Foundation

// `Bundle` Extension for SSAppUpdator.
internal extension Bundle {
    
    struct Constants {
        /// Constant for the `.bundle` file extension.
        static let bundleExtension = "bundle"
        
        /// Constant for `CFBundleShortVersionString`.
        static let shortVersionString = "CFBundleShortVersionString"
        
        /// Constant for `CFBundleIdentifier`.
        static let bundleIdentifier = "CFBundleIdentifier"
        
        /// Constant for `CFBundleDisplayName`.
        static let displayName = "CFBundleDisplayName"
    }
 
    /// Fetches the current version of the app.
    /// - Returns: The current installed version of the app.
    class func version() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: Constants.shortVersionString) as? String
    }
   
    /// Fetches the bundle identifier of the app.
    /// - Returns: The bundle identifier of the app.
    class func bundleIdentifier() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: Constants.bundleIdentifier) as? String
    }
    
    /// Get the name for the app to be displayed in the update alert.
    /// - Returns: The name of the app.
    class func getAppName() -> String {
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: Constants.displayName) as? String
        let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
        return bundleDisplayName ?? bundleName ?? ""
    }
    
}
