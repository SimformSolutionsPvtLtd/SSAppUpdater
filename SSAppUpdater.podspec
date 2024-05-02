#
#  Be sure to run `pod spec lint SSAppUpdater.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

 Pod::Spec.new do |s|
  s.name         = "SSAppUpdater"
  s.version      = "1.3.0"
  s.summary      = "SSAppUpdater is an open-source framework which notify the users about newly updated version on app store of the apps user already installed "


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

  s.source_files  = 'Sources/SSAppUpdater/**/*.swift'
  #s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  s.documentation_url = 'docs/index.html'
  s.resource = "Sources/SSAppUpdater/Resource/PrivacyInfo.xcprivacy"
end
