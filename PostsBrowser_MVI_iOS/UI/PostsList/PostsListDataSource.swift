//
//  PostsListDataSource.swift
//  PostsBrowser_MVI_iOS
//
//  Created by Sumit on 16/06/2019.
//  Copyright © 2019 Sumit. All rights reserved.
//

import UIKit

class PostsListDataSource: NSObject {
    
    private var posts = [Post]()
    private var users = [User]()
    
    func update(with posts: [Post], and users: [User]) {
        self.posts = posts
        self.users = users
    }
}

// MARK: - UITableViewDataSource
extension PostsListDataSource : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.posts.count > 0 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let post: Post = self.posts.item(at: indexPath.row) {
            let vm = PostListCellViewModelImpl(with: post)
            return PostListCell.dequeue(from: tableView, for: indexPath, with: vm)
        }
        
        return UITableViewCell()
    }
    
    
}
