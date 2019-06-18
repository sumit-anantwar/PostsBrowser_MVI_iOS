//
//  User.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 17/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation

struct User : Codable, Equatable {
    let id:         Int
    let name:       String
    let username:   String
    let email:      String
    
    func profileImageUrl() -> String {
        return "https://api.adorable.io/avatars/101/\(self.email)"
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
