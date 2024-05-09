//
//  AppDelegate.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodaria on 10/26/2020.
//  Copyright (c) 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SwiftUI

#if os(iOS)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Variables
    var window: UIWindow?
}

// MARK: - Delegate methods
extension AppDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = hostingController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }
}
#else
@main
struct SSAppUpdaterApp: App {
    // MARK: - Variables
        @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
}

// MARK: - Body View
extension SSAppUpdaterApp {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Variables
    var window: NSWindow!

}

// MARK: - Delegate methods
extension AppDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) { }

    func applicationWillTerminate(_ aNotification: Notification) { }
}
#endif

