//
//  Post.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 20/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import Foundation

struct Post : Codable, Equatable {
    let id:     Int
    let userId: Int
    let title:  String
    let body:   String
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
