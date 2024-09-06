//
//  SSAPIManager.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 20/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import Foundation

internal enum SSVersionError: Error {
    case invalidResponse
    case invalidBundleInfo
}

internal class SSAPIManager {
    
    /// Constants used for the iTunes Lookup API request.
    struct Constant {
        static let iTunesURL = "https://itunes.apple.com/lookup?bundleId="
        static let versionTag = "version"
        static let latestBuildURLTag = "latestBuildURL"
        static let applicationDir = "/Applications/"
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

// MARK: - Check for manual update
extension SSAPIManager {
    /**
     Performs a network request to check for a manual update from a specified server URL.

     - Parameters:
        - serverURL: The URL string pointing to the server endpoint where the update information is hosted.
        - completion: A closure to be called upon completion of the network request. It takes a single parameter:
            - content: A string containing the response data from the server, typically representing update information.
    */
    func checkForManualUpdate(serverURL: String, completion: @escaping ((String) -> Void)) {
        guard let url = URL(string: serverURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { 
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            guard httpResponse.statusCode == 200 else {
                return
            }
            guard let responseData = data else {
                return
            }
            guard let content = String(data: responseData, encoding: .utf8) else {
                return
            }
            completion(content)
        }
        task.resume()
    }
}
