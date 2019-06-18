//
//  ViewController.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 19/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import UIKit
import Swinject
import RxSwift
import RxCocoa
import RxOptional

fileprivate let FILTER_THRESHOLD = 1.0

class PostsListViewController: BaseViewController {

    @IBOutlet weak var viewTitle:           UIView!
    @IBOutlet weak var lblFilter:           UILabel!
    @IBOutlet weak var btnFilter:           RoundedButton!
    
    @IBOutlet weak var viewFilterFields:    UIView!
    @IBOutlet weak var textfieldUserId:     RoundedTextField!
    @IBOutlet weak var textfieldTitle:      RoundedTextField!
    @IBOutlet weak var textfieldBody:       RoundedTextField!
    
    @IBOutlet weak var tableView:           UITableView!
    
    private let dataSource =                PostsListDataSource()
    
    private var refreshControl:             UIRefreshControl!
    private var lblNoPostsMessage:          UILabel!
    private var lblNetworkErrorMessage:     UILabel!
    
    // TextField Observables
    private var userIdFieldObservable: Observable<String> {
        return textfieldUserId.rx
            .text
            .filterNil()
            .distinctUntilChanged()
    }
    
    private var titleFieldObservable: Observable<String> {
        return textfieldTitle.rx
            .text
            .filterNil()
            .distinctUntilChanged()
    }
    
    private var bodyFieldObservable: Observable<String> {
        return textfieldBody.rx
            .text
            .filterNil()
            .distinctUntilChanged()
    }
    
    // View Model
    private var viewModel:      PostsListViewModel!
    
    // Dispose Bag
    fileprivate let bag = DisposeBag()
    
    // Intent Publisher
    private let loadPostsPublisher = PublishSubject<PostsListIntent>()
    
    // MARK: - Swinject Initializer for the ViewController
    // Is called before viewDidLoad()
    // Properties set here can be safely used in viewDidLoad()
    func configure(with viewModel: PostsListViewModel) {
        
        self.viewModel                      = viewModel
    }
    
    // MARK: - Button Tap Listeners
    @IBAction func didTapFilterButton(_ sender: UIButton) {
        
        self.dismissKeyboard()
        
        UIView.animate(withDuration: 0.5) {
            self.viewFilterFields.isHidden = !self.viewFilterFields.isHidden
        }
    }
    
}



// MARK: - ViewController Lifecycle
extension PostsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Navbar
        self.configureNavBar(withTitle: .title_PostListView)
        
        // Setup UI
        self.uiSetup()
        
        // Configure TableView
        self.configureTableView()
        
        // Initialize the Subscribers
        self.rxSetup()
    }
}

// MARK: - RxSetup
fileprivate extension PostsListViewController {
    
    func rxSetup() {
        
        // Subscribe to ViewStates
        self.viewModel.states()
            .subscribe(onNext: { [weak self] viewState in
                self?.render(viewState: viewState)
            }).disposed(by: bag)
        
        // Pass Intents to the ViewModel
        self.viewModel.process(intents: intents())
        
        
        // Generate a combined observe
        // And throttle the events by 1 sec
        Observable.combineLatest(
            self.userIdFieldObservable,
            self.titleFieldObservable,
            self.bodyFieldObservable) { (userId, title, body) in
                return (userId, title, body)
            }
            .debounce(0.3, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] value in
                let (userId, title, body) = value
                
                self?.fetchPostsWith(userId: userId, title: title, body: body)
                
            }).disposed(by: bag)
    }
    
    func intents() -> Observable<PostsListIntent> {
        return loadPostsPublisher
    }
    
}

// MARK: - UI Setup
fileprivate extension PostsListViewController {
    
    func uiSetup() {
        
        // Title View
        self.viewTitle.backgroundColor = .primaryDark
        self.lblFilter.textColor = .white
        self.btnFilter.backgroundColor = .white
        self.btnFilter.cornerRadius = self.btnFilter.frame.height * 0.5
        
        // Filter Fields
        self.viewFilterFields.backgroundColor = .primaryLight
        self.viewFilterFields.isHidden = true
        
        // Create accessory Toolbar for the Keyboard
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        keyboardToolbar.barStyle = .blackTranslucent
        
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(dismissKeyboard))
        doneButtonItem.tintColor = .white
        
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        keyboardToolbar.items = [flexibleSpaceItem, doneButtonItem]
        keyboardToolbar.sizeToFit()
        
        // Apply the accessory toolbar to all the textFields
        self.textfieldUserId.inputAccessoryView = keyboardToolbar
        self.textfieldTitle.inputAccessoryView  = keyboardToolbar
        self.textfieldBody.inputAccessoryView   = keyboardToolbar
        
        // Generate TableView Error Labels
        self.lblNoPostsMessage          = self.tableViewErrorLabel(from: .error_NoPosts)
        self.lblNetworkErrorMessage     = self.tableViewErrorLabel(from: .error_NoNetwork)
        
    }
    
    func tableViewErrorLabel(from string: String) -> UILabel {
        
        // Create a Label tp be Displayed when the table is empty
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
        lbl.text = string
        lbl.textColor = .white;
        lbl.numberOfLines = 0;
        lbl.textAlignment = .center;
        lbl.font = .font_ErrorLabel
        lbl.backgroundColor = .clear
        lbl.sizeToFit()
        
        return lbl
    }
    
    func configureTableView() {
        // Register PostListTableViewCell with the TableView
        PostListCell.register(with: self.tableView)
        
        // Attributed Title for RefreshControl
        let title = NSAttributedString(string: .lbl_FetchingPosts, attributes: [.foregroundColor : UIColor.white])
        
        // Configure Refresh Control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = .primaryLight
        self.refreshControl.tintColor = .white
        self.refreshControl.attributedTitle = title
        self.refreshControl.addTarget(self, action: #selector(self.fetchPosts), for: .valueChanged)
        
        // Configure TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self.dataSource
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .primaryLight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 70
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.backgroundView = refreshControl
        }
    }
}

// MARK: - Private Action Methods
fileprivate extension PostsListViewController {
    
    /// Renders the ViewState
    func render(viewState: PostsListViewState) {
        
        // Render Loading State
        if viewState.isLoading {
            self.refreshControl.beginRefreshing()
        } else {
            self.refreshControl.endRefreshing()
        }
        
        // Render Error State
        if let error = viewState.error {
            if viewState.posts.count <= 0 {
                self.tableView.backgroundView = self.lblNetworkErrorMessage
            }
            else {
                self.tableView.backgroundView = nil
            }
            
            self.showAlert(with: .alertTitle_Attention, message: error.localizedDescription)
        }
        
        // Render Data
        self.dataSource.update(with: viewState.posts, and: viewState.users)
        self.tableView.reloadData()
        
        if !viewState.posts.isEmpty {
            self.tableView.backgroundView = nil
        } else {
            self.tableView.backgroundView = self.lblNoPostsMessage
        }
    }
    
    /// Launches Details View
    func launchDetailsView(for post: Post) {
        
        
        
    }
    
    /// Dismisses Keyboard
    @objc func dismissKeyboard() {
        self.textfieldUserId.resignFirstResponder()
        self.textfieldTitle.resignFirstResponder()
        self.textfieldBody.resignFirstResponder()
    }
    
    /// Fetches Posts on RefreshControl
    @objc func fetchPosts() {
        
        // initiating tableview refresh should consider current filter values
        let userId  = self.textfieldUserId.text ?? ""
        let title   = self.textfieldTitle.text  ?? ""
        let body    = self.textfieldBody.text   ?? ""
        
        
        self.fetchPostsWith(userId: userId, title: title, body: body)
    }
    
    /// Fetches Posts with Filter values from the EditTexts
    func fetchPostsWith(userId: String, title: String, body: String) {
        self.loadPostsPublisher.onNext(
            .loadPostsWithFilter(userId: userId, title: title, body: body)
        )
    }
}

// MARK: - UITableViewDelegate
extension PostsListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if let post = self.viewModel.post(at: indexPath.row) {
//            self.launchDetailsView(for: post)
//        }
    }
}


// MARK: - Swinject
class PostsListViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        
        container.storyboardInitCompleted(PostsListViewController.self) { (r, vc) in
            
            let viewModel = r.resolve(PostsListViewModel.self)!
            vc.configure(with: viewModel)
        }
        
    }
}
