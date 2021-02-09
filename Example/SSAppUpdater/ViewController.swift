//
//  ViewController.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodaria on 10/26/2020.
//  Copyright (c) 2020 Simform Solutions Pvt Ltd. All rights reserved.
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
        SSAppUpdater.shared.performCheck { (versionInfo) in
            print(versionInfo)
        }
    }

}
