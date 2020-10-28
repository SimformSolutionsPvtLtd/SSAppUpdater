//
//  SSAPIManager.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 20/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import UIKit

internal enum SSVersionError: Error {
    case invalidResponse
    case invalidBundleInfo
}

internal class SSAPIManager {
    
    /// Constants used for the iTunes Lookup API request.
    struct Constant {
        static let iTunesURL = "http://itunes.apple.com/lookup?bundleId="
    }
    
    // MARK: - Variable Declaration
    static let shared = SSAPIManager()
    
    // MARK: - Initializers
    private init() { }
    
    // MARK: - Function
    /// Parse the results from the iTunes Lookup API request.
    /// - Parameter completion: The completion handler for the iTunes Lookup API request.
    func getLookUpData(completion: @escaping (LookUpResponseModel?, Error?) -> Void) {
        guard let identifier = Bundle.bundleIdentifier(),
            let url = URL(string: "\(Constant.iTunesURL)\(identifier)") else {
                completion(nil, SSVersionError.invalidBundleInfo)
                return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw SSVersionError.invalidResponse }
                let responseModel = try JSONDecoder().decode(LookUpResponseModel.self, from: data)
                completion(responseModel, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
}
