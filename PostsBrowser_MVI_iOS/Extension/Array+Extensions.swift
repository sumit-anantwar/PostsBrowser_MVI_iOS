//
//  Array+Extensions.swift
//  SwissBorgTechTest
//
//  Created by Sumit Anantwar on 20/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import Foundation

extension Array {
    
    func item<T>(at index: Int) -> T? {
        if index < self.count {
            return self[index] as? T
        }
        
        return nil
    }
}
