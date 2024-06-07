# SSAppUpdater


SSAppUpdater is an open-source framework designed to streamline the process of comparing the current version of an app with the version available in the app store for iOS and macOS. It provides key details such as the app's URL, the new version number, and release notes. With this information, you can notify users about the availability of the latest version and redirect them to update the app. 

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![Carthage Compatible][carthage-image]][carthage-url]
[![SwiftPM Compatible][spm-image]][spm-url]
[![Platform][platform-image]][platform-url]
[![PRs Welcome][PR-image]][PR-url]

# Screenshots
#### Update Type(iOS)
| Force Update | Optional Update | Skip Version |
| :--: | :-----: | :--: |
| ![](Assets/ForceUpdateIOS.png) | ![](Assets/OptionalUpdateIOS.png) | ![](Assets/skipVersionIOS.png) |
    
#### Update Type(macOS)
| Force update | Optional update |
| :--: | :---: |
| ![](Assets/DefaultForceUpdateAlert.png) | ![](Assets/DefaultOptionalUpdateAlert.png) |

| Skip version | Update with custom alert |
| :--: | :---: |
| ![](Assets/DefaultSkipVersion.png) | ![](Assets/UpdateWithCustomAlert.png) |
# Features!
  - Check for new version of your installed application
  - Provides new version release note
  - Provides AppID and AppStore URL
  - Provides support of custom alerts for updates.
  - CocoaPods

# Requirements
  - iOS 13.0+
  - macOS 11.0+
  - Xcode 9+

# Installation
#### CocoaPods
 
- You can use CocoaPods to install SSAppUpdater by adding it to your Podfile:

       use_frameworks!
       pod 'SSAppUpdater'

- import SSAppUpdater

#### Manually
-   Download and drop **SSAppUpdater** folder in your project.
-   Congratulations!

#### Swift Package Manager
-   When using Xcode 11 or later, you can install `SSAppUpdater` by going to your Project settings > `Swift Packages` and add the repository by providing the GitHub URL. Alternatively, you can go to `File` > `Swift Packages` > `Add Package Dependencies...`
```swift
dependencies: [
    .package(url: "https://github.com/SimformSolutionsPvtLtd/SSAppUpdater.git", from: "1.1.0")
]
```

####  Carthage
-   [Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.You can install Carthage with [Homebrew](http://brew.sh/) using the following command:
```bash
$ brew update
$ brew install carthage
```
To integrate `SSAppUpdater` into your Xcode project using Carthage, add the following line to your `Cartfile`:

```ogdl
github ""SimformSolutionsPvtLtd/SSAppUpdater""
```
Run `carthage` to build and drag the `SSAppUpdater`(Sources/SSAppUpdater) into your Xcode project.

# How It Works
- SSAppUpdater compares the currently installed version of your iOS app with the new store version that is currently available in the App Store. When an update is available, SSAppUpdater is able to present the new version number, Appstore URL, App ID, and release notes to the user giving them the choice to update.
- In case of default alert, If you receive a new version update alert but lose internet connection, it will not allow you to redirect to the app store and will display an alert.

- How does SSAppUpdater achieve this? Firstly, it makes use of the **iTunes Search API** to retrieve the information. 

- To use the default alert, call SSAppUpdater.shared.performCheck with the following parameters:

    - `isForceUpdate` - Boolean value checks that the user wants to force update or not.
    - `updateAlertFrequency` - The user can choose alert display time. default value will be `.always`. Alternative values of this property are `daily`,`weekly` and `monthly`.
    - `skipVersionAllow` - This feature lets users activate the "skipVersion" functionality.
    - `redirectToMacAppStore` - This setting is specifically for macOS users. It gives them the choice to either be directed to the App Store app or stay within the current application to access the App Store.
    - `completion` - This will provide you with version information in the completion block.
    
- To use the custom alert, call `SSAppUpdater.shared.performCheckAndDisplayCustomAlert` with the following parameter:
    - `completion` - This will provide you with version information in the completion block.
    
# Usage example
#### Implementation
    
- Implementing SSAppUpdater quite easy just add below provided code in your `AppDelegate.swift` or anywhere in your app you need.
- The block will provide version information which can then be utilized to generate an custom alert.

    ```swift
        //defaultExample
        SSAppUpdater.shared.performCheck { (versionInfo) in
        // Version Info have all the app update related information
        // Display AppUpdate UI based on versionInfo.isAppUpdateAvailable flag
        }

        //customExample
        SSAppUpdater.shared.performCheckAndDisplayCustomAlert { (versionInfo) in
        // Version Info have all the app update related information
        }
    ```

# Inspired 
-  SSAppUpdater inspired from [Siren](https://github.com/ArtSabintsev/Siren)


[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[carthage-image]:https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
[carthage-url]: https://github.com/Carthage/Carthage
[spm-image]:https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg
[spm-url]: https://swift.org/package-manager
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


## Check out our other Libraries

<h3><a href="https://github.com/SimformSolutionsPvtLtd/Awesome-Mobile-Libraries"><u>🗂 Simform Solutions Libraries→</u></a></h3>
