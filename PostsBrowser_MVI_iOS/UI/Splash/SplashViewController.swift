//
//  SplashViewController.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 19/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import UIKit
import Swinject
import Lottie

class SplashViewController: UIViewController {

    private var coordinator: MainCoordinator?
    private var animationView: AnimationView!
    
    // MARK: - Swinject Initializer for the ViewController
    func configure(with mainCoordinator: MainCoordinator) {
        self.coordinator = mainCoordinator
    }
    
}

// MARK: - ViewController Lifecycle
extension SplashViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.primary
        
        self.animationView = AnimationView(name: "heartbeat")
        self.animationView.translatesAutoresizingMaskIntoConstraints = false
        self.animationView.loopMode = .playOnce
        self.animationView.tintColor = UIColor.white
        self.animationView.contentMode = .scaleAspectFit
        
        self.view.addSubview(self.animationView)
        
        // Set Constraint on the AnimationView
        var margins = self.view.layoutMarginsGuide
        if #available(iOS 11, *) {
            margins = self.view.safeAreaLayoutGuide
        }
        
        self.animationView.widthAnchor.constraint(equalTo: margins.widthAnchor)
        self.animationView.heightAnchor.constraint(equalToConstant: 100)
        self.animationView.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        self.animationView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.animationView.play { didComplete in
            if didComplete {
                self.launchMainVC()
            }
        }
    }
}

private extension SplashViewController {
    
    func launchMainVC() {
        
        if let coordinator = self.coordinator {
            coordinator.start()
            self.present(coordinator.navigationController, animated: true, completion: nil)
        }
    }
    
}

// MARK: - Swinject Assembly
class SplashViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        
        container.storyboardInitCompleted(SplashViewController.self) { (r, vc) in
            
            let mainCoordinator = r.resolve(MainCoordinator.self)!
            vc.configure(with: mainCoordinator)
        }
    }
    
}
