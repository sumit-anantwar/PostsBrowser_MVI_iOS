//
//  PostsListViewControllerMvi.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 19/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation

// MARK: - Intents
enum PostsListIntent: MviIntent {
    case loadPostsWithFilter(userId: String , title: String, body: String)
    case loadAllUsersIntent
}

// Actions
enum PostsListAction: MviAction {
    case loadPostsWithFilterAction(userId: String, title: String, body: String)
    case loadAllUsersAction
}


// Results
enum LoadPostsResult : MviResult {
    case loading
    case success(posts: [Post])
    case failure(error: Error)
}


