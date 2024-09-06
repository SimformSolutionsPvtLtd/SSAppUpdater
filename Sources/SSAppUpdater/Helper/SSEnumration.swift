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
