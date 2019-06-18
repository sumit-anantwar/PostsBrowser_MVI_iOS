//
//  PostsApi.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 16/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import Foundation
import Moya

enum PostsAPI {
    case fetchAllPosts
    case fetchAllPostsForUser(userId: String)
    case fetchSinglePost(postId: Int)
    case fetchAllUsers
    case fetchSingleUser(userId: Int)
    case fetchCommentsForPost(postId: Int)
}

extension PostsAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com") else {
            Log.fatalError(message: "API Url is not valid")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .fetchAllPosts:
            return "/posts"
        case .fetchAllPostsForUser(_):
            return "/posts"
        case .fetchSinglePost(let id):
            return "/posts/\(id)"
        case .fetchAllUsers:
            return "/users"
        case .fetchSingleUser(let userId):
            return "/users/\(userId)"
        case .fetchCommentsForPost(_):
            return "/comments"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        
        switch self {
        case .fetchAllPosts:
            return stubbedResponseForAllPosts()
        case let .fetchAllPostsForUser(userId):
            return stubbedResponseForUserPosts(userId)
        case let .fetchSinglePost(postId):
            return stubbedResponseForPostWithId(postId)
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .fetchAllPostsForUser(let userId):
            
            if !userId.isEmpty, let intUserId = userId.toInt() {
                // Return a parameterized request only if userId is not empty,
                // and is in fact an integer
                return .requestParameters(parameters: ["userId" : intUserId], encoding: URLEncoding.queryString)
            }
            // Else return a plain request
            return .requestPlain
            
        case .fetchCommentsForPost(let postId):
            return .requestParameters(parameters: ["postId" : postId], encoding: URLEncoding.queryString)
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}



// MARK: - Stubbed Responses for Testing
private func loadPostsData() -> [Post] {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    guard let url = bundle.url(forResource: "AllPosts", withExtension: "json") else {
        Log.fatalError(message: "Dataset not found", event: .error)
    }
    
    do {
        let postsData = try Data(contentsOf: url)
        let posts = try JSONDecoder().decode([Post].self, from: postsData)
        return posts
    }
    catch let error {
        Log.fatalError(message: error.localizedDescription, event: .error)
    }
}

func stubbedResponseForAllPosts() -> Data {
    let allPosts = loadPostsData()
    guard let postsData = allPosts.toJSONData() else {
        Log.fatalError(message: "Could not convert Posts to JSON Data")
    }
    
    return postsData
}

func stubbedResponseForUserPosts(_ userId: String) -> Data {
    let allPosts = loadPostsData()
    
    var filteredPosts = allPosts
    if !userId.isEmpty, let intUserId = userId.toInt() {
        filteredPosts = allPosts.filter { $0.userId == intUserId }
    }
    
    guard let postsData = filteredPosts.toJSONData() else {
        Log.fatalError(message: "Could not convert Posts to JSON Data")
    }
    
    return postsData
}

func stubbedResponseForPostWithId(_ postId: Int) -> Data {
    let allPosts = loadPostsData()
    let post = allPosts.filter { $0.id == postId }.first
    
    if (post != nil),
        let postData = post!.toJSONData() {
        return postData
    }
    else {
        let emptyArray: [String] = []
        return emptyArray.toJSONData()!
    }
}
