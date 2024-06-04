//
//  PerformVersionCheckFromServer.swift
//  Pods
//
//  Created by Rishita Panchal on 26/05/24.
//

import Foundation

class PerformVersionCheckFromServer {
    static let shared = PerformVersionCheckFromServer()

    struct PerformVersionCheckFromServer {
        static let versionTag = "version"
        static let latestBuildURLTag = "latestBuildURL"
        static let applicationDir = "/Applications/"
    }

    func checkForAutoUpdeate() {
        guard let url = URL(string: "") else { return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            guard httpResponse.statusCode == 200 else {
                print("Response status code: \(httpResponse.statusCode)")
                return
            }
            guard let responseData = data else {
                print("No data received")
                return
            }
            guard let content = String(data: responseData, encoding: .utf8) else {
                print("Unable to convert data to string")
                return
            }
            if let version = self.getXMLTagValue(
                content: content,
                tagName: PerformVersionCheckFromServer.versionTag
            ), let latestBuildURL = self.getXMLTagValue(
                content: content,
                tagName: PerformVersionCheckFromServer.latestBuildURLTag
            ), self.compareVersions(
                newBuildVersion: String(version),
                currentBuildVersion: Bundle.appVersion ?? ""
            ) == .orderedDescending {
                if !FileManager.default.fileExists(atPath: self.latestBuildFileURL(url: url).path) {
                    print("Not exist")
                } else {
                    print("exist")
                }
                DispatchQueue.main.async {
                    SSAlertManager.shared.showAlert(
                        releaseNote: "releaseNote",
                        isForceUpdate: SSAppUpdater.shared.isForceUpdate,
                        appStoreVersion: version,
                        skipVersionAllow: SSAppUpdater.shared.skipVersionAllow,
                        dismissParentViewController: { },
                        primaryButtonAction: {
                            print("Updated")
                        }
                    )
                }
            } else {  }
        }
        task.resume()

    }


    private func getXMLTagValue(content: String, tagName: String) -> String? {
        if let startIndex = content.range(of: "<\(tagName)>")?.upperBound,
           let endIndex = content.range(of: "</\(tagName)>", range: startIndex ..< content.endIndex)?.lowerBound {
            return String(content[startIndex ..< endIndex])
        } else {
            return nil
        }
    }

    func compareVersions(newBuildVersion: String, currentBuildVersion: String) -> ComparisonResult {
        let newVersionArray = newBuildVersion.extractVersionComponent()
        let currentVersionArray = currentBuildVersion.extractVersionComponent()
        if newVersionArray.lexicographicallyPrecedes(currentVersionArray) {
            return .orderedAscending
        } else if currentVersionArray.lexicographicallyPrecedes(newVersionArray) {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }

//    private func replaceAndRelaunchWithLatestBuild(url: URL) {
//        let script = AppleScripts.replaceAppInApplicationDirectory(
//            appName: Bundle.getAppName(),
//            source: self.latestBuildFileURL(url: url).path,
//            destination: AppConstants.applicationDir
//        ).script
//        guard let appleScript = NSAppleScript(source: script) else { return }
//        DispatchQueue.global(qos: .background).async {
//            var error: NSDictionary?
//            let scriptResult = appleScript.executeAndReturnError(&error)
//            DispatchQueue.main.async {
//                if let error = error {
////                    self.displayForceUpdateFailureAlert()
////                    textLogFileManager.writeLogToFile(text: appStrings.appReplacementFailure("\(error)"), logFileUrl: .autoUpdate)
//                } else {
//                    if let result = scriptResult.stringValue {
////                        printInfo(message: result)
////                        self.deleteFile(at: self.latestBuildFileURL(url: url))
////
////                        // Quit & relaunch .app file
////                        _ = ScriptOrCommandExecutor.executeCommand("killall '\(appName)' && open -a '\(appName)'")
//                    }
//                }
//            }
//        }
//    }

    private func latestBuildFileURL(url: URL) -> URL {
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Application Support/\(Bundle.main.bundleIdentifier ?? "")/AutoUpdate/")
            .appendingPathComponent(url.lastPathComponent)
    }
}

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
