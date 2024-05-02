//
//  AppStoreView.swift
//  SSAppUpdater
//
//  Created by Rishita Panchal on 24/04/24.
//

import StoreKit
import SwiftUI

#if os(macOS)
internal struct AppStoreView: NSViewControllerRepresentable {
    // MARK: - Variables
    let trackId: Int
}

// MARK: - Constants
extension AppStoreView {
    struct AppStoreViewConstants {
        static let baseAppStroreUrl = "macappstore://itunes.apple.com/app/id"
    }
}

// MARK: - Functions
extension AppStoreView {
    func makeNSViewController(context: Context) -> SKStoreProductViewController {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = context.coordinator
        return storeViewController
    }

    func updateNSViewController(_ nsViewController: SKStoreProductViewController, context: Context) {
        let parameters = [SKStoreProductParameterITunesItemIdentifier: trackId]
        nsViewController.loadProduct(withParameters: parameters) { _, error in
            if let error {
                goToAppStoreApplication()
                print(error.localizedDescription)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}

// MARK: - SKStoreProductViewControllerDelegate function
extension AppStoreView {
    class Coordinator: NSObject, SKStoreProductViewControllerDelegate {
        func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
            viewController.dismiss(nil)
        }
    }

    func goToAppStoreApplication() {
        if let appStoreURL = URL(string: "\(AppStoreViewConstants.baseAppStroreUrl)\(trackId)") {
            NSWorkspace.shared.open(appStoreURL)
        }
    }
}
#endif
