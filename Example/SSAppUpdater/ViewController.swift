//
//  ViewController.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodaria on 10/26/2020.
//  Copyright (c) 2020 Mansi Vadodaria. All rights reserved.
//

import UIKit
import StoreKit
import SSAppUpdater

class ViewController: UIViewController {

    var versionInfo: SSVersionInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Implement following code to Perform App Update Check
        SSAppUpdater.shared.performCheck { [weak self] (versionInfo) in
            guard let self = self else {
                return
            }
            print(versionInfo)
            self.versionInfo = versionInfo
            if versionInfo.isAppUpdateAvailable {
                self.displayAppUpdateAlert()
            }
        }
    }

    private func displayAppUpdateAlert() {
        let updateAction = UIAlertAction(title: "Update", style: .default, handler: { (_) in
            self.launchAppUpdate()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
        })
        let alert = UIAlertController.showAlert(title: Bundle.getAppName(),
                                             message: self.versionInfo?.appReleaseNote ?? "",
                                             actions: [updateAction, cancelAction], preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    private func launchAppUpdate() {
        guard let appID = self.versionInfo?.appID else {
            return
        }
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        let itunesIdentifier = NSNumber(value: appID)
        storeViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: itunesIdentifier],
                                        completionBlock: { [weak self] (_, error) in
            guard let self = self else {
                return
            }
            if error != nil {
                print("Error occurred while loading the product: \(error.debugDescription)")
            } else {
                DispatchQueue.main.async {
                    self.present(storeViewController, animated: true)
                }
            }
        })
    }

}

extension ViewController: SKStoreProductViewControllerDelegate {

    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

}
