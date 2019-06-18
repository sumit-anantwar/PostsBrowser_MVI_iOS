//
//  DependencyRegistry.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 16/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation
import Swinject


protocol DependencyRegistry {}

class DependencyRegistryImpl : DependencyRegistry {
    
    private let container: Container
    private let assembler: Assembler
    
    init(container: Container) {
        // Disable Logging
        Container.loggingFunction = nil
        
        self.container = container
        self.assembler = Assembler(container: container)
     
        // Assemble
        self.assembleDependencies()
        self.assembleUi()
    }
}

// MARK: - Dependencies
extension DependencyRegistryImpl {
    
    private func assembleDependencies() {
        
        // NetworkManager
        assembler.apply(assembly: NetworkManagerAssembly())
        
    }
    
}

// MARK: - Assembler
extension DependencyRegistryImpl {
    
    private func assembleUi() {
    
        // MainCoordinator
        self.assembler.apply(assembly: MainCoordinatorAssembly())
        
        // Splash
        self.assembler.apply(assembly: SplashViewControllerAssembly())
        
        // PostsList
        self.assembler.apply(assembly: PostsListViewModelAssembly())
        self.assembler.apply(assembly: PostsListViewControllerAssembly())
    }
    
}
