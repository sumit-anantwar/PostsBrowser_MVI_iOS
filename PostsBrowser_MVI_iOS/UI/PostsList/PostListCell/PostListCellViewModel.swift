//
//  PostListCellPresenter.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 21/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import Foundation

protocol PostListCellViewModel {
    var id:     Int     { get }
    var userId: Int     { get }
    var title:  String  { get }
    var body:   String  { get }
}

class PostListCellViewModelImpl : PostListCellViewModel {
    
    fileprivate let post: Post
    init(with post: Post) {
        self.post = post
    }
    
    // MARK: - Public Accessors
    var id: Int         { return self.post.id }
    var userId: Int     { return self.post.userId }
    var title: String   { return self.post.title }
    var body: String    { return self.post.body }
}
