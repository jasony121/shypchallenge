source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.1'
pod 'AFNetworking', '2.6.0'
pod 'Mantle', '2.0.4'
pod 'Nimbus', '1.2.0'
pod 'FSOAuth', '1.0'


target 'ShypChallengeTests', exclusive: true do
    pod 'KIF', '3.2.3'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = 'NO'
        end
    end
end
