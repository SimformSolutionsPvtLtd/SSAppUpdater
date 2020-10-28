//
//  UserDefaults.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 21/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import Foundation

// `UserDefaults` Extension for SSAppUpdator.
extension UserDefaults {
    
    private enum UserDefaultKeys: String {
        /// Key that stores the alert Presentation Date of the last version check.
        case alertPresentationDate
        
        /// Key that stores the skip version.
        case skipVersion
    }
   
    /// Sets and Gets a `UserDefault` that stores the alert Presentation Date of the last version check.
    static var alertPresentationDate: Date? {
        get {
            return standard.object(forKey: UserDefaultKeys.alertPresentationDate.rawValue) as? Date
        } set {
            standard.set(newValue, forKey: UserDefaultKeys.alertPresentationDate.rawValue)
            standard.synchronize()
        }
    }
    
    static var skipVersion: String? {
        get {
            return standard.value(forKey: UserDefaultKeys.skipVersion.rawValue) as? String
        } set {
            standard.set(newValue, forKey: UserDefaultKeys.skipVersion.rawValue)
            standard.synchronize()
        }
    }

}
