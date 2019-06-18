//
//  SwinjectStoryboard+Extensions.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 16/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    public static func setup() {
        if AppDelegate.dependencyRegistry == nil {
            AppDelegate.dependencyRegistry = DependencyRegistryImpl(container: defaultContainer)
        }
    }
}
