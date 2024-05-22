//
//  SSAppUpdater.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 20/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import Foundation

public class SSAppUpdater {
    // MARK: - Variables
    public static let shared = SSAppUpdater()

    private var versionCheck: PerformVersionCheck!
    
    internal var showDefaultAlert: Bool = true
    
    var updateAlertFrequency: SSUpdateFrequency = .always
    
    var isForceUpdate: Bool = false
    
    var redirectToAppStore: Bool = false

    var skipVersionAllow: Bool = false
    
    // MARK: - Initialisers
    private init() { }
}

// MARK: - Functions
extension SSAppUpdater {
    /** Shows the update alert.
        - Parameters:
         - isForceUpdate: A boolean value indicating whether the user wants to **forceUpdate** or **OptionalUpdate**.
         - updateAlertFrequency: The frequency at which the user wants to perform the app update.
         - showDefaultAlert: A boolean value indicating whether the user wants to show the default `UIAlertController` or custom UI.
         - redirectToAppStoreInMac: A boolean value indicating whether the app should redirect to the App Store on macOS.
         - completion: A closure to return Version Information (App Version Info).
         - skipVersionAllow: A boolean value indicating whether it will allow for **Skip Version** in Alert Controller.
     **/
    public func performCheck(
        isForceUpdate: Bool = false,
        updateAlertFrequency: SSUpdateFrequency = .always,
        showDefaultAlert: Bool = true,
        skipVersionAllow: Bool = false,
        redirectToAppStore: Bool = false,
        completion: @escaping (SSVersionInfo) -> Void
    ) {
        self.isForceUpdate = isForceUpdate
        self.updateAlertFrequency = updateAlertFrequency
        self.showDefaultAlert = showDefaultAlert
        self.skipVersionAllow = skipVersionAllow
        self.redirectToAppStore = redirectToAppStore
        self.versionCheck = PerformVersionCheck(completion: completion)
    }
}
