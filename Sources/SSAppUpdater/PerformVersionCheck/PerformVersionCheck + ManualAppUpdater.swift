//
//  PerformVersionCheck + ManualAppUpdater.swift
//  Pods
//
//  Created by Rishita Panchal on 05/07/24.
//

import Foundation

#if os(macOS)
// MARK: - Perform version check manual
extension PerformVersionCheck {
    /**
     Performs a manual version check for app updates by querying a remote server for the latest version details. If a newer version is available, it optionally downloads the new build and displays an alert to the user with release notes.

     - Parameters:
        - serverURL: A `String` representing the URL of the server that provides version information in XML format.
    */
    func processManualVersionCheck(from serverURL: String) {
        URLCache.shared.removeAllCachedResponses()
        SSAPIManager.shared.checkForManualUpdate(serverURL: serverURL) { result in
            switch result {
            case .success(let content):
                if let version = self.getXMLTagValue(
                    content: content,
                    tagName: PerformVersionCheckConstants.versionTag
                ), let latestBuildURL = self.getXMLTagValue(
                    content: content,
                    tagName: PerformVersionCheckConstants.latestBuildURLTag
                ), self.compareVersions(
                    newBuildVersion: String(version),
                    currentBuildVersion: Bundle.appVersion ?? ""
                ) == .orderedDescending, UserDefaults.skipVersion != version {
                    let releaseNote = self.getArrayOfXMLTagValues(content: content, tagName: "note")
                    let formattedReleaseNote = releaseNote.map { "• \($0)" }.joined(separator: "\n")
                    guard let url = URL(string: latestBuildURL) else { return }
                    if !FileManager.default.fileExists(atPath: self.latestBuildFileURL(url: url).path) {
                        self.downloadUpdatedBuild(urlString: latestBuildURL) { isLatestAutoUpdateFileDownloaded in
                            self.displayUpdateAlert(
                                version: version,
                                formattedReleaseNote: formattedReleaseNote,
                                url: url
                            )
                        }
                    } else {
                        self.displayUpdateAlert(
                            version: version,
                            formattedReleaseNote: formattedReleaseNote,
                            url: url
                        )
                    }
                    self.completion(
                        SSVersionInfo(
                            isAppUpdateAvailable: nil,
                            appReleaseNote: formattedReleaseNote,
                            appVersion: version,
                            appID: nil,
                            appURL: nil
                        )
                    )
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    SSAlertManager.shared.showAlert(
                        alertIcon: PerformVersionCheckConstants.warningSystemImage,
                        title: PerformVersionCheckConstants.manualMacAppUpdateErrorTitle,
                        subTitle: error.message,
                        primaryButtonTitle: PerformVersionCheckConstants.ok,
                        primaryButtonAction: { },
                        secondaryButtonTitle: nil,
                        secondaryButtonAction: { },
                        cancelButtonTitle: SSAppUpdater.shared.isForceUpdate ? nil : PerformVersionCheckConstants.cancel,
                        cancelButtonAction: { }
                    )
                }
            }
        }
    }

    /// Common function to extract XML tag values
    private func extractXMLTagValues(content: String, tagName: String) -> [String] {
        var values = [String]()
        let pattern = "<\(tagName)>(.*?)</\(tagName)>"

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsrange = NSRange(content.startIndex..<content.endIndex, in: content)
            let matches = regex.matches(in: content, options: [], range: nsrange)

            for match in matches {
                if let range = Range(match.range(at: 1), in: content) {
                    let value = String(content[range])
                    values.append(value)
                }
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return values
    }

    /// Function to get a single XML tag value
    private func getXMLTagValue(content: String, tagName: String) -> String? {
        return extractXMLTagValues(content: content, tagName: tagName).first
    }

    /// Function to get an array of XML tag values
    private func getArrayOfXMLTagValues(content: String, tagName: String) -> [String] {
        return extractXMLTagValues(content: content, tagName: tagName)
    }

    /**
     Compares two version strings to determine their relationship.

     - Parameters:
        - newBuildVersion: The version string of the new build to be compared.
        - currentBuildVersion: The version string of the current build to be compared against.

     - Returns: A `ComparisonResult` value indicating the relationship between the two version strings.
    */
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


    /**
     Deletes a file located at the specified file URL.

     - Parameter fileURL: The URL of the file to be deleted.
    */
    private func deleteFile(at fileURL: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }

    /**
     Downloads the latest app build from a given URL and saves it to the appropriate file location on the disk. Once the download is complete, the result is passed back via a completion handler.

     - Parameters:
        - urlString: A `String` representing the URL from which the updated build will be downloaded.
        - completion: A closure that is called with a `Bool` indicating the success (`true`) or failure (`false`) of the download operation.
*      */
    private func downloadUpdatedBuild(urlString: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }

        let destinationURL = self.latestBuildFileURL(url: url)
        let session = URLSession.shared
        let task = session.downloadTask(with: url) { (tempLocalURL, response, error) in
            if error != nil {
                completion(false)
                return
            }

            guard let tempLocalURL else {
                completion(false)
                return
            }

            do {
                let directory = destinationURL.deletingLastPathComponent()
                try FileManager.default.createDirectory(
                    at: directory,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }
                try FileManager.default.moveItem(at: tempLocalURL, to: destinationURL)
                completion(true)
            } catch {
                completion(false)
            }
        }

        task.resume()
    }


    /**
     Constructs the file URL for storing the latest downloaded build.

     - Parameter url: The URL of the latest downloaded build.
     - Returns: A URL pointing to the location where the latest build will be stored.
    */
    private func latestBuildFileURL(url: URL) -> URL {
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Application Support/\(Bundle.main.bundleIdentifier ?? "")/AutoUpdate/")
            .appendingPathComponent(url.lastPathComponent)
    }

    /**
     Replaces the current application build with the latest version and relaunches the application.

     This private function initiates the process to replace the current application build with the latest version downloaded from the specified URL. It utilizes an AppleScript to perform the replacement, followed by the relaunching of the application.

     - Parameters:
        - url: The URL of the latest build to be installed.
    */
    private func replaceAndRelaunchWithLatestBuild(url: URL) {
        let appName = Bundle.getAppName()
        let script = AppleScripts.replaceAppInApplicationDirectory(
            appName: appName,
            source: self.latestBuildFileURL(url: url).path,
            destination: PerformVersionCheckConstants.applicationDir
        ).script
        guard let appleScript = NSAppleScript(source: script) else { return }
        DispatchQueue.global(qos: .background).async {
            var error: NSDictionary?
            let scriptResult = appleScript.executeAndReturnError(&error)
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    if let result = scriptResult.stringValue {
                        print(result)
                        self.deleteFile(at: self.latestBuildFileURL(url: url))
                        
                        // Quit & relaunch .app file
                        _ = SSScriptOrCommandExecutor.executeCommand("killall '\(appName)' && open -a '\(appName)'")
                    }
                }
            }
        }
    }
}

extension PerformVersionCheck {
    /**
     Displays an alert to notify the user about a new app version update. The alert includes the version number, release notes, and options to update, skip the version, or cancel.

     - Parameters:
        - version: A `String` representing the new app version that is available for download.
        - formattedReleaseNote: A `String` containing the formatted release notes for the new version, typically in a bulleted format.
        - url: A `URL` pointing to the location of the latest app build that will be downloaded and installed if the user chooses to update.
    */
    private func displayUpdateAlert(version: String, formattedReleaseNote: String, url: URL) {
        DispatchQueue.main.async {
            SSAlertManager.shared.showAlert(
                alertIcon: PerformVersionCheckConstants.updateSystemImage,
                title: Bundle.getAppName(),
                subTitle: "\n A new version \(version) \n\n \(formattedReleaseNote)",
                primaryButtonTitle: PerformVersionCheckConstants.update,
                primaryButtonAction: {
                    self.replaceAndRelaunchWithLatestBuild(url: url)
                },
                secondaryButtonTitle: SSAppUpdater.shared.skipVersionAllow ? PerformVersionCheckConstants.skipThisVersion : nil,
                secondaryButtonAction: { 
                    UserDefaults.skipVersion = version
                },
                cancelButtonTitle: SSAppUpdater.shared.isForceUpdate ? nil : PerformVersionCheckConstants.cancel,
                cancelButtonAction: { }
            )
        }
    }
}
#endif
