//
//  MainCoordinator.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 17/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import UIKit
import Swinject

protocol MainCoordinator: Coordinator {
    
}

class MainCoordinatorImpl : MainCoordinator {
    var children: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        
        let plVC: PostsListViewController = PostsListViewController.storyboardInstance.instantiate()
        
        self.navigationController.pushViewController(plVC, animated: true)
    }
}

// MARK: - Swinject Assembly
class MainCoordinatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MainCoordinator.self) { r in
            let navc = UINavigationController()
            navc.modalTransitionStyle = .crossDissolve
            
            return MainCoordinatorImpl(with: navc)
        }
    }
}
