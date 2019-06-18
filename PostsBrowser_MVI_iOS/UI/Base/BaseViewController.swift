//
//  BaseViewController.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 22/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import UIKit
import Moya

// Enum for left bar button type
internal enum LeftNavigationBarButtonType {
    
    // Left navigation bar button is not present
    case none
    
    // Left navigation bar button is the back button
    case back
}


internal class BaseViewController: UIViewController {
    
}

internal extension BaseViewController {
    
    func configureNavBar(withTitle title: String,
                         leftBarButtonType: LeftNavigationBarButtonType = .none) {
        
        self.title = title
        
        if let navbar = self.navigationController?.navigationBar {
            navbar.barTintColor = .primary
            navbar.titleTextAttributes = [
                .foregroundColor: UIColor.white
            ]
            
            switch leftBarButtonType {
            case .none:
                self.navigationItem.leftBarButtonItem = nil
            case .back:
                self.navigationItem.leftBarButtonItem = self.backButtonItem()
            }
        }
        
    }
    
}

// MARK: - Left Bar Button Items
fileprivate extension BaseViewController {
    
    func backButtonItem() -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back") , style: .plain, target: self, action: #selector(self.backButtonTapped))
        barButtonItem.tintColor = .white
        
        return barButtonItem
    }
    
}

// MARK: - Button Tap Listeners
internal extension BaseViewController {
    
    /// Go back on back button tap
    @objc func backButtonTapped() {
        
        // Check for navigation controller
        guard let navController = self.navigationController else {
            
            // Just dismiss
            self.dismiss(animated: true, completion: nil)
            return
        }
        navController.popViewController(animated: true)
    }
}

internal extension BaseViewController {
    
    func showAlert(with title: String, message: String, andActions actions: [UIAlertAction]? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                alertController.addAction(action)
            }
        }
        else {
            alertController.addAction(UIAlertAction(title: .btnTitle_OK, style: .cancel, handler: nil))
        }
        
        // Presenting the Error Popup immediately blocks the endRefreshing animation
        // Show the popup after 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
}
