//
//  SSViewController.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 22/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import StoreKit

class SSViewController: UIViewController {
    
    var currentWindow: UIWindow!
    var releaseNote: String = ""
    var trackID: Int?
    var appStoreVersion: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SSAppUpdater.shared.isForceUpdate {
            showForceAlert()
        } else {
            showOptionalAlert()
        }
    }
    
    deinit {
        currentWindow = nil
    }
    
    private func showForceAlert() {
        let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in
            self.launchAppUpdate()
        }
        
        let alert = UIAlertController.showAlert(title: Bundle.getAppName(), message: "\n A new version \(appStoreVersion) \n\n \(releaseNote)", actions: [updateAction], preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func showOptionalAlert() {
        UserDefaults.alertPresentationDate = Date()
        let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in
            self.launchAppUpdate()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            DispatchQueue.main.async {
                self.dismiss(animated: false)
            }
        }
        let skipAction = UIAlertAction(title: "Skip this version", style: .default) { (action) in
            DispatchQueue.main.async {
                UserDefaults.skipVersion = self.appStoreVersion
                self.dismiss(animated: false)
            }
        }
        var actions: [UIAlertAction] = []
        actions.append(updateAction)
        if SSAppUpdater.shared.skipVersionAllow {
            actions.append(skipAction)
        }
        actions.append(cancelAction)
        let alert = UIAlertController.showAlert(title: Bundle.getAppName(), message: "\n A new version \(appStoreVersion) \n\n \(releaseNote)", actions: actions, preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func launchAppUpdate() {
        guard let trackID = self.trackID else {
            return
        }
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        storeViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:NSNumber(value: trackID)]) {[weak self] (result, error) in
            guard let self = self else {
                return
            }
            if(error != nil) {
                print("Error occurred while loading the product: \(error.debugDescription)")
            }
            else {
                DispatchQueue.main.async {
                    self.present(storeViewController, animated: true)
                }
            }
        }
    }
    
}

extension SSViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true) {[weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.currentWindow = nil
            }
        }
        viewController.dismiss(animated: true, completion: nil)
    }
}
