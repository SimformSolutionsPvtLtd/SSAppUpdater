//
//  SSAppUpdater.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 20/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import UIKit

public class SSAppUpdater {
    
    // MARK: - Variable Declaration
    /// The SSAppUpdator singleton.
    public static let shared = SSAppUpdater()
    
    private var versionCheck: PerformVersionCheck!
    
    internal var showDefaultAlert: Bool = true
    
    var updateAlertFrequency: SSUpdateFrequency = .always
    
    var isForceUpdate: Bool = false
    
    var skipVersionAllow: Bool = false
    
    // MARK: - Initializers
    private init() { }
    
     // MARK: - Function
    /// All default parameter are implemented
    /// - Parameters:
    ///   - isForceUpdate: Boolean value check that user wants to forceUpdate or OptionalUpdate.
    ///   - updateAlertFrequency: The frequency in which the user wants to perform update the app
    ///   - showDefaultAlert: Boolean value check that user wants to show default `UIAlertController` or customUI.
    ///   - completion: Return Version Information (App Version Info)
    ///   - skipVersionAllow: Boolean value check that It will Allow for Skip Version in Alert Controller
    public func performCheck(isForceUpdate: Bool = false, updateAlertFrequency: SSUpdateFrequency = .always, showDefaultAlert: Bool = true, skipVersionAllow: Bool = false, completion: @escaping (SSVersionInfo) -> Void ) {
        self.isForceUpdate = isForceUpdate
        self.updateAlertFrequency = updateAlertFrequency
        self.showDefaultAlert = showDefaultAlert
        self.skipVersionAllow = skipVersionAllow
        self.versionCheck = PerformVersionCheck(completion: completion)
    }
}
