//
//  NetworkManager.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 20/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import Foundation
import Swinject
import RxSwift
import Moya

protocol NetworkManager {
    
    /**
     Fetches all the posts
     - parameter onSuccess: A block object that gets called on successful completion of the request
     - parameter onFailure: A block object that gets called on failure of the request
     */
    func allPosts() -> Single<[Post]>
    
    /**
     Fetches all the posts
     - parameter userId: User Id for the posts to be fetched
     - parameter title: String used to filter the title text
     - parameter body: String used to the filter the body text
     - parameter onSuccess: A block object that gets called on successful completion of the request
     - parameter onFailure: A block object that gets called on failure of the request
     */
    func allPosts(with userId: String, title: String, body: String) -> Single<[Post]>
    
    /**
     Fetches the post for the specified id
     - parameter id: The Id of the Post to be fetched
     - parameter onSuccess: A block object that gets called on successful completion of the request
     - parameter onFailure: A block object that gets called on failure of the request
     */
    func post(withId id: Int) -> Single<Post>
    
    func fetchAllUsers() -> Single<[User]>
    
    func fetchAllComments(for postId: Int)
}

class NetworkManagerImpl {
    
    // PostsProvider
    fileprivate let provider: MoyaProvider<PostsAPI>
    
    // Dispose Bag
    fileprivate var bag = DisposeBag()
    
    // plugins: [NetworkLoggerPlugin(verbose: true)])
    init(with provider: MoyaProvider<PostsAPI> = MoyaProvider<PostsAPI>()) {
        self.provider = provider
    }
    
    // To cancel the request simply dispose all the subscribers
    func cancelRequests() {
        self.bag = DisposeBag()
    }
}

extension NetworkManagerImpl : NetworkManager {
    
    /// Fetch all Posts
    func allPosts() -> Single<[Post]> {

        return provider.rx
            .request(.fetchAllPosts)
            .map([Post].self)
    }
    
    func allPosts(with userId: String) -> Single<[Post]> {
        
        return provider.rx
            .request(.fetchAllPostsForUser(userId: userId))
            .filterSuccessfulStatusCodes()
            .map([Post].self)
    }
    
    func allPosts(with userId: String, title: String, body: String) -> Single<[Post]> {
        
        // JSONPlaceholder does not have a filter API
        // To simulate the functionality we can fetch all the posts for the user Id
        // and then apply filter locally
        // if the userId is nil, we shall fetch all the posts
        
        // Filter
        func applyFilter(_ posts: [Post]) -> [Post] {
            
            let fTitle  = title.isEmpty ? " " : title
            let fBody   = body.isEmpty  ? " " : body
            
            let filteredPosts =  posts.filter { post in
                (post.title.range(of: fTitle, options: .caseInsensitive) != nil) &&
                (post.body.range(of: fBody, options: .caseInsensitive) != nil)
            }
            
            return filteredPosts
        }
        
        if userId.isEmpty {
            return self.allPosts().map(applyFilter)
        } else {
            return self.allPosts(with: userId).map(applyFilter)
        }
    }
    
    func post(withId id: Int) -> Single<Post> {
        
        return provider.rx
            .request(.fetchSinglePost(postId: id))
            .map(Post.self)
    }
    
    func fetchAllUsers() -> Single<[User]> {
        
        return provider.rx
            .request(.fetchAllUsers)
            .map([User].self)
    }
    
    func fetchAllComments(for postId: Int) {
        //TODO: To Be Implemented
    }
}


// MARK: - Swinject

class NetworkManagerAssembly: Assembly {
    func assemble(container: Container) {
        
        // Register NetworkManager in Contaiener Scope
        container.register(NetworkManager.self) { r in
            return NetworkManagerImpl()
            
        }.inObjectScope(.container)
    }
}

