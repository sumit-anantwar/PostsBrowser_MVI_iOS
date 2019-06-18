//
//  ActivityIndicator.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 07/01/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import UIKit

protocol ActivityIndicator {
    func showActivityIndicator()
    func hideActivityIndicator()
}

private let INDICATOR_TAG = 9999192 // Using a random tag to avoid conflicts

extension UIActivityIndicatorView {
    func start() {
        self.startAnimating()
        self.isHidden = false
    }
    
    func stop() {
        self.stopAnimating()
        self.isHidden = true
    }
}


extension ActivityIndicator where Self: UIViewController {
    
    /// Swift does not allow stored properties in an extension
    /// to circumvent this issue, we use the below logic for providing an UIActivityIndicatorView
    private var indicatorView: UIActivityIndicatorView {
        // Check if a view with tag has already been added to the Controller's view
        // and, try to cast it to UIActivityIndicatorView
        // If the view exists, we have teh reference to the UIActivityIndicatorView
        // so, we can return the same
        guard let indicator = self.view.viewWithTag(INDICATOR_TAG) as? UIActivityIndicatorView else {
            
            // If the view does not exist
            // we create a new UIActivityIndicatorView,
            // assign the tag to it, add it to the Controller's view
            // and return it
            // This way, every UIViewController conforming to this protocol will automatically get a UIActivityIndicatorView
            let i = UIActivityIndicatorView(style: .whiteLarge)
            i.color = .gray
            i.isHidden = true
            i.tag = INDICATOR_TAG
            i.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(i)
            
            // Constraint the center of the activity indicator to the center of the Controller's view
            var margins = self.view.layoutMarginsGuide
            if #available(iOS 11, *) {
                margins = self.view.safeAreaLayoutGuide
            }
            i.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
            i.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
            
            return i
        }
        
        return indicator
    }
    
    /// Shows the UIActivityIndicatorView and starts animating
    func showActivityIndicator() {
        self.view.bringSubviewToFront(self.indicatorView)
        self.indicatorView.startAnimating()
        self.indicatorView.isHidden = false
    }
    
    /// Hides the UIActivityIndicatorView and stops animating
    func hideActivityIndicator() {
        self.view.sendSubviewToBack(self.indicatorView)
        self.indicatorView.isHidden = true
        self.indicatorView.stopAnimating()
    }
    
}
