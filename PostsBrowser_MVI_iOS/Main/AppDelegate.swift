//
//  AppDelegate.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 14/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import UIKit
import Swinject
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Dependency Registry
    static var dependencyRegistry: DependencyRegistry!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        return true
    }
}

