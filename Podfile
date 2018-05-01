source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ‘9.0’
use_frameworks!

target 'QiitaReader’ do
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'TOWebViewController'
  pod 'APIKit', '~> 3.1'
  pod 'Nuke', '~> 6.0'
  pod 'TagListView', '~> 1.0'
  pod 'RealmSwift'
end

# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

