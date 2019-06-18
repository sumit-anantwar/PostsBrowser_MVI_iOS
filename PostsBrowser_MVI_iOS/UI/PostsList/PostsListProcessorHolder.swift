//
//  PostsListProcessorHolder.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 17/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

protocol PostsListProcessorHolder {
    func actionProcessor(_ action: Observable<PostsListAction>) -> Observable<LoadPostsResult>
}

class PostsListProcessorHolderImpl {
    
    private let networkManager: NetworkManager
    
    init(with networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

extension PostsListProcessorHolderImpl : PostsListProcessorHolder {
    
    func actionProcessor(_ action: Observable<PostsListAction>) -> Observable<LoadPostsResult> {
        return action.flatMap(processAction)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .startWith(.loading)
    }
    
    private func processAction(_ action: PostsListAction) -> Single<LoadPostsResult> {
        switch action {
            
        case .loadPostsWithFilterAction(let userId, let title, let body):
            return self.networkManager.allPosts(with: userId, title: title, body: body)
                .map { posts in
                    return LoadPostsResult.success(posts: posts)
                }
                .catchError { error in
                    return Single.just(LoadPostsResult.failure(error: error))
            }
            
        // FIXME: Dont not refer below, this is just a placeholder
        case .loadAllUsersAction:
            return self.networkManager.allPosts()
                .map { posts in
                    return .success(posts: posts)
                }
                .catchError { error in
                    return Single.just(LoadPostsResult.failure(error: error))
            }
        }
        
    }
    
}
