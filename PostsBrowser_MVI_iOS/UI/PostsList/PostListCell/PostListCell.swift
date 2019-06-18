//
//  PostListTableViewCell.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 19/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import UIKit

class PostListCell: UITableViewCell {

    @IBOutlet weak var lblPostId: RoundedLabel!
    @IBOutlet weak var lblPostTitle: UILabel!
    @IBOutlet weak var lblUserIdTitle: UILabel!
    @IBOutlet weak var lblUserId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

fileprivate extension PostListCell {
    
    func configure(with viewModel: PostListCellViewModel) {
        // Post Id
        self.lblPostId.cornerRadius     = self.lblPostId.frame.width * 0.5
        self.lblPostId.backgroundColor  = .primary
        self.lblPostId.borderColor      = .primaryDark
        self.lblPostId.borderWidth      = 2.0
        self.lblPostId.text             = viewModel.id.toString()
        
        self.lblPostTitle.text  = viewModel.title
        self.lblUserId.text     = viewModel.userId.toString()
        
    }
    
}


//MARK: - Helper Methods
extension PostListCell {
    public static var cellId: String {
        return String(describing: PostListCell.self)
    }
    
    public static var bundle: Bundle {
        return Bundle(for: PostListCell.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: PostListCell.cellId, bundle: PostListCell.bundle)
    }
    
    public static func register(with tableView: UITableView) {
        tableView.register(PostListCell.nib, forCellReuseIdentifier: PostListCell.cellId)
    }
    
    public static func loadFromNib(owner: Any?) -> PostListCell {
        return bundle.loadNibNamed(PostListCell.cellId, owner: owner, options: nil)?.first as! PostListCell
    }
    
    
    public static func dequeue(from tableView: UITableView, for indexPath: IndexPath, with postListCellViewModel: PostListCellViewModel) -> PostListCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: PostListCell.cellId, for: indexPath) as! PostListCell
        cell.configure(with: postListCellViewModel)
        cell.backgroundColor = (indexPath.row % 2 == 0) ? .cellEven : .cellOdd
        
        return cell
    }
}
