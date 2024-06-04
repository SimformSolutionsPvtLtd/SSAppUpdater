//
//  PerformVersionCheckFromServer.swift
//  Pods
//
//  Created by Rishita Panchal on 26/05/24.
//

import Foundation

extension String {
    func extractVersionComponent() -> [Int] {
        return components(separatedBy: ".").compactMap { Int($0) }
    }
}


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

extension PerformVersionCheck {
    func getVersionCheckFromServer(serverURL: String) {
        SSAPIManager.shared.checkForManualUpdate(serverURL: serverURL) { newVersionDetails in
            print(newVersionDetails)
        }
    }
}
