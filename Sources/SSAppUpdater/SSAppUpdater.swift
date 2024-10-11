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

    /// A shared instance of `SSAppUpdater` for singleton access.
    public static let shared = SSAppUpdater()

    /// An instance of `PerformVersionCheck` used for checking app versions.
    private var versionCheck: PerformVersionCheck!

    /// A boolean flag indicating whether to show the default update alert.
    internal var showDefaultAlert: Bool = true

    /// The frequency at which the update alert should be displayed.
    var updateAlertFrequency: SSUpdateFrequency = .always

    /// A boolean flag indicating whether the update is a forced update.
    var isForceUpdate: Bool = false

    /// A boolean flag indicating whether to redirect to the App Store for updates.
    var redirectToAppStore: Bool = false

    /// A boolean flag indicating whether the user is allowed to skip version updates.
    var skipVersionAllow: Bool = false

    /// The URL of the server used for manual macOS updates.
    var serverURL: String = ""

    /// A boolean flag indicating whether the app updater is in manual update mode.
    var isManualAppUpdater = false

    // MARK: - Initialisers
    private init() { }
}

// MARK: - Functions
extension SSAppUpdater {
    /**
     Performs a version check and displays a system's default alert based on the result.
     - Parameters:
        - isForceUpdate: A boolean value indicating whether the user wants to **forceUpdate** or **optionalUpdate**.
        - updateAlertFrequency: The frequency at which the user wants to perform the app update.
        - redirectToAppStore: A boolean value indicating whether the app should redirect to the App Store.
        - completion: A closure to return Version Information (App Version Info).
        - skipVersionAllow: A boolean value indicating whether it will allow for **Skip Version** in the Alert Controller.
    */
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
        self.versionCheck = PerformVersionCheck(isManualMacOSUpdate: false, completion: completion)
    }

    /**
     Performs a version check and displays a custom alert based on the result.

     This method initiates a version check process and upon completion, invokes the provided completion handler with the version information. You can use that version information in your custom alert

     - Parameters:
        - completion: A closure to be called upon completion of the version check process. The closure receives an `SSVersionInfo` object containing the version information.
    */
    public func performCheckAndDisplayCustomAlert(completion: @escaping (SSVersionInfo) -> Void) {
        self.showDefaultAlert = false
        self.versionCheck = PerformVersionCheck(isManualMacOSUpdate: false, completion: completion)
        self.isManualAppUpdater = false
    }

    /**
    Performs a version check using version information from an XML file.

    This function initiates a version check by fetching and parsing version data from a specified XML file URL. The result of the check is provided through a completion handler that returns an `SSVersionInfo` object.

    - Parameters:
        - url: A `String` representing the URL of the XML file containing version information.
        - isForceUpdate: A `Bool` indicating whether the version check should force an update, even if the version is up-to-date. The default value is `false`.
        - completion: A closure that takes an `SSVersionInfo` object as a parameter. This closure is executed when the version check is complete, providing the fetched version information.
    */
    public func performManualMacAppVersionCheck(
        url: String,
        isForceUpdate: Bool = false,
        skipVersionAllow: Bool = false,
        completion: @escaping (SSVersionInfo) -> Void
    ) {
        self.serverURL = url
        self.isForceUpdate = isForceUpdate
        self.skipVersionAllow = skipVersionAllow
        self.versionCheck = PerformVersionCheck(
            isManualMacOSUpdate: true,
            completion: completion
        )
        self.isManualAppUpdater = true
    }
}
