//
//  SSVersionInfo.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 22/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import Foundation

/// Provide App details of the app store version
public struct SSVersionInfo {
    
    /// checks that App update avialble or not. if it is true then new App Version is available on the App Store.
    public let isAppUpdateAvailable: Bool!
    
    /// It holds the new release notes of the current App Version available on the App Store.
    public let appReleaseNote: String?
    
    /// It holds the New App Version available on the App Store.
    public let appVersion: String?
    
    /// It holds the TrackId of the App on the App Store.
    /// It is used for navigate to App Store if user used SKStoreProductViewController
    public let appID: Int?
    
    /// It holds the TrackViewURL of the App on the App Store.
    /// It is used for navigate to App Store.
    public let appURL: String?
    
}
