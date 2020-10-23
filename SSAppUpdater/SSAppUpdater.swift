//
//  SSAppUpdater.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 20/10/20.
//  Copyright © 2020 Mansi Vadodariya. All rights reserved.
//

import UIKit

public class SSAppUpdater {
    
    // MARK: - Variable Declaration
    /// The SSAppUpdator singleton.
    public static let shared = SSAppUpdater()
    
    private var versionCheck: PerformVersionCheck!
    
    // MARK: - Initializers
    private init() { }
    
     // MARK: - Function
    /// All default parameter are implemented
    /// - Parameters:
    ///   - isForceUpdate: Boolean value check that user wants to forceUpdate or OptionalUpdate.
    ///   - completion: Return Version Information (App Version Info)
    public func performCheck(completion: @escaping (SSVersionInfo) -> Void ) {
        self.versionCheck = PerformVersionCheck(completion: completion)
    }
}
