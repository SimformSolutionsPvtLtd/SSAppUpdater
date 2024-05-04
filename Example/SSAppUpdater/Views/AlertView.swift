//
//  AlertView.swift
//  SSAppUpdater
//
//  Created by Rishita Panchal on 03/05/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI

struct AlertView: View {
    // MARK: variables
    let title: String
    let subTitle: String
    let action: (() -> Void)
}

// MARK: - Body view
extension AlertView {
    var body: some View {
        VStack(spacing: 0) {
            alertIcon
            alertContent
            updateButton
        }
        #if os(iOS)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        #else
        .frame(width: 300, height: 180)
        .padding(.horizontal, 50)
        .padding(.bottom, 25)
        .fixedSize()
        #endif
    }
}

// MARK: Private views
extension AlertView {
    private var alertIcon: some View {
        Image(systemName: "clock")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .padding(.bottom, 15)

    }
    private var alertContent: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .lineLimit(nil)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Text(subTitle)
                .lineLimit(nil)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var updateButton: some View {
        Button(action: { } ) {
            Text("Update")
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .frame(height: 30)
        .background(Color.blue)
        .cornerRadius(10)
        .padding(.vertical, 7)
        .padding(.horizontal, 50)
        .padding(.top, 10)
    }
}
