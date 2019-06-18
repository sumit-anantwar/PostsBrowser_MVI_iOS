//
//  BaseCoordinator.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 17/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var children:               [Coordinator] { get set }
    var navigationController:   UINavigationController { get set }
    
    func start()
}
