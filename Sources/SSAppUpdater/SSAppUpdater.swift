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
    /**
     Performs a version check and displays a systems default alert based on the result.
        - Parameters:
         - isForceUpdate: A boolean value indicating whether the user wants to **forceUpdate** or **OptionalUpdate**.
         - updateAlertFrequency: The frequency at which the user wants to perform the app update.
         - redirectToAppStoreInMac: A boolean value indicating whether the app should redirect to the App Store on macOS.
         - completion: A closure to return Version Information (App Version Info).
         - skipVersionAllow: A boolean value indicating whether it will allow for **Skip Version** in Alert Controller.
     **/
    public func performCheck(
        isForceUpdate: Bool = false,
        updateAlertFrequency: SSUpdateFrequency = .always,
        skipVersionAllow: Bool = false,
        redirectToAppStore: Bool = false,
        completion: @escaping (SSVersionInfo) -> Void
    ) {
        self.isForceUpdate = isForceUpdate
        self.showDefaultAlert = true
        self.updateAlertFrequency = updateAlertFrequency
        self.skipVersionAllow = skipVersionAllow
        self.redirectToAppStore = redirectToAppStore
        self.versionCheck = PerformVersionCheck(completion: completion)
    }

    /**
     Performs a version check and displays a custom alert based on the result.

     This method initiates a version check process and upon completion, invokes the provided completion handler with the version information. You can use that version information in your custom alert

     - Parameters:
        - completion: A closure to be called upon completion of the version check process. The closure receives an `SSVersionInfo` object containing the version information.
    */
    public func performCheckAndDisplayCustomAlert(completion: @escaping (SSVersionInfo) -> Void) {
        self.showDefaultAlert = false
        self.versionCheck = PerformVersionCheck(completion: completion)
    }
}
