# Uncomment the next line to define a global platform for your project
platform :ios, '9.1'

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# Ignore all warnings from all pods
inhibit_all_warnings!


def core
    pod 'RxSwift',				    '4.5.0'
    pod 'RxCocoa',				    '4.5.0'
    pod 'RxOptional',			    '3.6.2'
    pod 'RxSwiftExt',				  '3.4.0'
    pod 'Moya/RxSwift',			  '13.0.1'
    
    # Swinject
    pod 'Swinject',				    '2.6.1'
    pod 'SwinjectStoryboard',	'2.2.0'
    
    # Lottie
    pod 'lottie-ios'
    
    # Fabric Crashlytics
    pod 'Fabric',				      '1.10.1'
    pod 'Crashlytics',			  '3.13.1'
end

def testing
    pod 'RxBlocking',			    '4.5.0'
    pod 'RxTest',				      '4.5.0'
end

target 'PostsBrowser_MVI_iOS' do

  core

  target 'PostsBrowser_MVI_iOSTests' do
    inherit! :search_paths
    
    testing
  end

  target 'PostsBrowser_MVI_iOSUITests' do
    inherit! :search_paths
    
    testing
  end

end
