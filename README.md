<a href="https://www.simform.com/"><img src="https://github.com/SimformSolutionsPvtLtd/SSToastMessage/blob/master/simformBanner.png"></a>
# SSAppUpdater


SSAppUpdater is an open-source framework that compares the current version of the app with the store version and returns the essential details of it like app URL, new app version number, new release note, etc. So you can either redirect or notify the user to update their app. 

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![Platform][platform-image]][platform-url]
[![PRs Welcome][PR-image]][PR-url]

![Alt text](https://github.com/SimformSolutionsPvtLtd/SSAppUpdater/blob/master/SSAppUpdate.png?raw=true)

# Features!
  - Check for new version of your installed application
  - Provides new version release note
  - Provides AppID and AppStore URL
  - CocoaPods

# Requirements
  - iOS 10.0+
  - Xcode 9+

# Installation
 **CocoaPods**
 
- You can use CocoaPods to install SSAppUpdater by adding it to your Podfile:

       use_frameworks!
       pod 'SSAppUpdater'

- import SSAppUpdater

**Manually**
-   Download and drop **SSAppUpdater** folder in your project.
-   Congratulations!

# Usage example


**Implementation**

Implementing SSAppUpdater quite easy just add two line code in your `AppDelegate.swift` or anywhere in your app you need. (The block will return the version info)


### AppDelegate.swift Example
```swift
import SSAppUpdater
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()

        SSAppUpdater.shared.performCheck { (versionInfo) in
            // Version Info have all the app update releated information
            // Display AppUpdate UI based on versionInfo.isAppUpdateAvailable flag
        }
    }
}
```


[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/assets/svg/badges/C-ffb83f-7198e9a1b7ad7f73977b0c9a5c7c3fffbfa25f262510e5681fd8f5a3188216b0.svg
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
[platform-image]:https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat
[platform-url]:http://cocoapods.org/pods/LFAlertController
[cocoa-image]:https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg
[cocoa-url]:https://img.shields.io/cocoapods/v/LFAlertController.svg
[PR-image]:https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square
[PR-url]:http://makeapullrequest.com
