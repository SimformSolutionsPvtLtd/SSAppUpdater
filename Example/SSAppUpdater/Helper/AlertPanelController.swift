//
//  AlertPanelController.swift
//  SSAppUpdater
//
//  Created by Rishita Panchal on 03/05/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI

#if os(iOS)

// MARK: - iOS AlertManager
class AlertManager {
    // MARK: - Variables
    static let shared = AlertManager()
    private var alertWindow: UIWindow?
}

// MARK: - Function
extension AlertManager {
    func showAlertWindow(title: String, subTitle: String, action: (() -> Void)) {
        let alertView = AlertView(title: title, subTitle: subTitle, action: {})
        let window = UIWindow(frame: UIScreen.main.bounds)
        let hostingController = UIHostingController(rootView: GeometryReader { geometry in
            alertView
                .frame(width: 300, height: geometry.size.height)
                .background(Color.clear)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        })

        hostingController.view.backgroundColor = UIColor.clear // Ensure background is clear
        window.rootViewController = hostingController
        window.windowLevel = .alert + 1
        window.makeKeyAndVisible()
        alertWindow = window
    }
}

#else
// MARK: - macOS AlertManager
class AlertManager: NSWindowController {
    // MARK: - Variables
    static let shared = AlertManager()
    private var alertWindow: NSPanel

    // MARK: - Initialisers
    private init() {
        alertWindow = NSPanel(
            contentRect: .zero,
            styleMask: [.titled, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        super.init(window: nil)
        alertWindow.titlebarAppearsTransparent = true
    }

    required init?(coder: NSCoder) {
        fatalError("Something went wrong!!")
    }
}

// MARK: - Show alert window
extension AlertManager {
    func showAlertWindow(
        title: String,
        subTitle: String,
        action: @escaping (() -> Void)
    ) {
        let contentView = AlertView(
            title: title,
            subTitle: subTitle, 
            action: action
        )
        placeAlertWindow(panel: alertWindow, contentView: contentView)
        alertWindow.makeKeyAndOrderFront(nil)
    }

    func placeAlertWindow(
        panel: NSPanel,
        contentView: some View
    ) {
        let contentView = NSHostingView(rootView: contentView)
        panel.contentView = contentView
        contentView.wantsLayer = true
        contentView.layer?.masksToBounds = true
        contentView.layer?.cornerRadius = 20
        let screenFrame = NSScreen.main?.visibleFrame ?? .zero
        let panelFrame = panel.frame
        let xOffset = (screenFrame.width - panelFrame.width) / 2
        let yOffset = (screenFrame.height - panelFrame.height) / 2
        let newOrigin = NSPoint(
            x: screenFrame.origin.x + xOffset,
            y: screenFrame.origin.y + yOffset
        )
        panel.setFrameOrigin(newOrigin)
    }
}
#endif
