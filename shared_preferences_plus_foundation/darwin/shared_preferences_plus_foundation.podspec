#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint shared_preferences_plus_foundation.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'shared_preferences_plus_foundation'
  s.version          = '1.1.0'
  s.summary          = 'Named-container preferences storage for iOS and macOS.'
  s.description      = <<-DESC
Named-container preferences storage for iOS and macOS.
                       DESC
  s.homepage         = 'https://github.com/sanjeev2552/shared_preferences_plus'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Sanjeev' => 'https://github.com/sanjeev2552' }

  s.source           = { :path => '.' }
  s.source_files = 'shared_preferences_plus_foundation/Sources/shared_preferences_plus_foundation/**/*.swift'

  s.resource_bundles = {'shared_preferences_plus_foundation_privacy' => ['shared_preferences_plus_foundation/Sources/shared_preferences_plus_foundation/Resources/PrivacyInfo.xcprivacy']}

  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
