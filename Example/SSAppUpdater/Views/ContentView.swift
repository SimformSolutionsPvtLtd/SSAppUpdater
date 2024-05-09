//
//  ContentView.swift
//  SSAppUpdater_Example
//
//  Created by Rishita Panchal on 22/04/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import SSAppUpdater

// MARK: - Body view
struct ContentView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onAppear(perform: {
                    SSAppUpdater.shared.performCheck { (versionInfo) in
                        print(versionInfo)
                    }

                    /// Uncomment below function to display custom alert
                    // checkForUpdateDisplayCustomAlert()
                })
        }
        .frame(width: 500, height: 500)
    }
}

// MARK: - Private view
extension ContentView {
    private func checkForUpdateDisplayCustomAlert() {
        SSAppUpdater.shared.performCheck(showDefaultAlert: false) { (versionInfo) in
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
}

#Preview {
    ContentView()
}
