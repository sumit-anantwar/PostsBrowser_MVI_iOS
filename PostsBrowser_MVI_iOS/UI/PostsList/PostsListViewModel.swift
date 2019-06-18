//
//  PostListViewModel.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 19/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import Foundation
import Swinject
import RxSwift
import RxOptional

protocol PostsListViewModel {
    
    func process(intents: Observable<PostsListIntent>)
    func states() -> Observable<PostsListViewState>
}

class PostsListViewModelImpl : PostsListViewModel {
    
    private let intentSubject = PublishSubject<PostsListIntent>()
    private lazy var statesObservable: Observable<PostsListViewState> = compose()
    
    // MARK: - Designated Initializer
    private let processorHolder: PostsListProcessorHolder
    
    /**
     Designated Initializer
     - parameter networkManager: Network Manager instance used to make the requests
     */
    init(with processorHolder: PostsListProcessorHolder) {
        self.processorHolder = processorHolder
    }
    
    // Streams
    func process(intents: Observable<PostsListIntent>) {
        intents.subscribe(intentSubject)
    }
    
    func states() -> Observable<PostsListViewState> {
        return statesObservable
    }
}


private extension PostsListViewModelImpl {
    
    func compose() -> Observable<PostsListViewState> {
        return self.intentSubject
            .map(actionFromIntent)
            .apply(self.processorHolder.actionProcessor)
            .scan(PostsListViewState.idle(), accumulator: reducer)
    }
    
    func actionFromIntent(_ intent: PostsListIntent) -> PostsListAction {
        switch intent {
        case .loadPostsWithFilter(let userId, let title, let body):
            return .loadPostsWithFilterAction(userId: userId, title: title, body: body)
        case .loadAllUsersIntent:
            return .loadAllUsersAction
        }
    }
    
    func reducer(_ previousState: PostsListViewState, _ result: LoadPostsResult) -> PostsListViewState {
        var mutableState = previousState
        
        switch result {
        case .loading:
            mutableState.isLoading = true
        
        case .success(let posts):
            mutableState.isLoading = false
            mutableState.posts = posts
            
        case .failure(let error):
            mutableState.isLoading = false
            mutableState.error = error
        }
        
        return mutableState
    }
    
    
}


// MARK: - Swinject Assembly
class PostsListViewModelAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(PostsListViewModel.self) { r in
            
            let networkManager = r.resolve(NetworkManager.self)!
            let processorHolder = PostsListProcessorHolderImpl(with: networkManager)
            
            return PostsListViewModelImpl(with: processorHolder)
        }
    }
}
