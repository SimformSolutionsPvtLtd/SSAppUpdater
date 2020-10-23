//
//  Bundle.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 21/10/20.
//  Copyright © 2020 Mansi Vadodariya. All rights reserved.
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
    
}
