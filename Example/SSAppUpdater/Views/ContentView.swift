//
//  ContentView.swift
//  SSAppUpdater_Example
//
//  Created by Rishita Panchal on 22/04/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import SSAppUpdater

// MARK: - Constants
struct ContentView: View {
    //
    struct Constants {
        static let serverURL = "https://ontime-release-test.s3.ap-south-1.amazonaws.com/Release/version.xml"
    }
}

// MARK: - Body view
extension ContentView {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onAppear(perform: {
                    checkForManualMacAppUpdate()

                    /// Uncomment below function to display default alert
                    /// checkForUpdateDisplayDefaultAlert()

                    /// Uncomment below function to display custom alert
                    /// checkForUpdateDisplayCustomAlert()
                })
        }
        .frame(width: 500, height: 500)
    }
}

// MARK: - Private view
extension ContentView {
    private func checkForManualMacAppUpdate() {
        SSAppUpdater.shared.performManualMacAppVersionCheck(
            url: ContentView.Constants.serverURL,
            isForceUpdate: true
        ) { versionInfo in
            print(versionInfo)
        }
    }

    private func checkForUpdateDisplayCustomAlert() {
        SSAppUpdater.shared.performCheckAndDisplayCustomAlert { (versionInfo) in
            DispatchQueue.main.async {
                if let appVersion = versionInfo.appVersion,
                    let releaseNote = versionInfo.appReleaseNote {
                    AlertManager.shared.showAlertWindow(
                        title: " New version:  \(appVersion)",
                        subTitle: releaseNote, 
                        action: {}
                    )
                }
            }
        }
    }

    private func checkForUpdateDisplayDefaultAlert() {
        SSAppUpdater.shared.performCheck { (versionInfo) in
            print(versionInfo)
        }
    }
}

#Preview {
    ContentView()
}
