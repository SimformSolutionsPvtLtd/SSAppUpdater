//
//  Enumration.swift
//  Pods
//
//  Created by Rishita Panchal on 28/08/24.
//

import Foundation


// MARK: - Apple scripts
enum AppleScripts {
    case replaceAppInApplicationDirectory(appName: String, source: String, destination: String)
}

extension AppleScripts {
    var script: String {
        switch self {
        case let .replaceAppInApplicationDirectory(appName, source, destination):
            return """
                    do shell script "rm -rf '/Applications/\(appName).app'; unzip '\(source)' -d '\(destination)';" with administrator privileges
            """
        }
    }
}

// MARK: - Custom Error
enum CustomError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case noData
    case dataEncodingError
    case networkError(Error)
    case other(Error)

    var message: String {
        switch self {
        case .invalidURL:
            return """
                The URL provided is not valid. Please ensure that the URL string is correctly formatted.
            """
        case .invalidResponse:
            return "The server response is invalid or unexpected."
        case .serverError(let statusCode):
            return "The server returned an error with status code: \(statusCode)."
        case .noData:
            return "No data was received from the server."
        case .dataEncodingError:
            return "There was an error encoding the data into a string format."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)."
        case .other(let error):
            return "API error: \(error.localizedDescription)."
        }
    }
}
