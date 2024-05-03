//
//  ContentView.swift
//  SSAppUpdater_Example
//
//  Created by Rishita Panchal on 22/04/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import SSAppUpdater

struct ContentView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onAppear(perform: {
                    SSAppUpdater.shared.performCheck(skipVersionAllow: true) { (versionInfo) in
                        print(versionInfo)
                    }
                })
        }
        .frame(width: 500, height: 500)
    }
}

#Preview {
    ContentView()
}
