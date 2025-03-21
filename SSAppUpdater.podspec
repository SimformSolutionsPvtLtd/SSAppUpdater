#
#  Be sure to run `pod spec lint SSAppUpdater.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

 Pod::Spec.new do |s|
  s.name         = "SSAppUpdater"
  s.version      = "1.7.0"
  s.summary      = "SAppUpdater is an open-source framework for iOS and macOS that checks the current app version against the latest App Store version, providing the app URL, version number, and release notes. On macOS, it also supports manual updates, allowing apps to offer version checks and updates outside the App Store."


  s.homepage     = 'https://github.com/SimformSolutionsPvtLtd/SSAppUpdater.git'
  
  #s.license      = "MIT"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "Simform Solutions" => "developer@simform.com" }
  s.platform = :ios
  s.platform = :osx

  s.ios.deployment_target = "13.0"
  s.osx.deployment_target = "11.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/SimformSolutionsPvtLtd/SSAppUpdater.git", :tag => "#{s.version}" }
  #s.source       = { :path => ".", :tag => "#{s.version}" }

  s.source_files = 'Sources/**/*'
  #s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  s.documentation_url = 'docs/index.html'
  s.resources = "Sources/SSAppUpdater/Resource/PrivacyInfo.xcprivacy"
end
