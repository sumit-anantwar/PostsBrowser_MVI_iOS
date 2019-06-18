//
//  PosstListViewState.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 17/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation

struct PostsListViewState : MviViewState, Equatable {
    
    var isLoading: Bool
    var posts: [Post]
    var users: [User]
    var error: Error?
    
    static func idle() -> PostsListViewState {
        return PostsListViewState(isLoading: false,
                                  posts: [],
                                  users: [],
                                  error: nil)
    }
    
    static func initial() -> PostsListViewState {
        return PostsListViewState(isLoading: true,
                                  posts: [],
                                  users: [],
                                  error: nil)
    }

    static func == (lhs: PostsListViewState, rhs: PostsListViewState) -> Bool {
        return (lhs.isLoading == rhs.isLoading) &&
            (lhs.posts == rhs.posts) &&
            (lhs.users == rhs.users) &&
            (lhs.error?.localizedDescription == rhs.error?.localizedDescription)
    }
}
