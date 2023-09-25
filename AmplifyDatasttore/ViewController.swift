//
//  ViewController.swift
//  AmplifyDatasttore
//
//  Created by David Perez Espino on 22/09/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var postTableView: UITableView!
    
    let datastore = DataStoreHelper()
    
    var postList: [Post] = [
        Post(
            title: "example",
            status: .active,
            rating: 4,
            content: "Lorem ipsum dolor sit amet, consectetur in."
        )
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardViewCellNib: UINib = UINib(nibName: PostViewCell.nibName, bundle: Bundle(for: type(of: self)))
        self.postTableView.register(cardViewCellNib, forCellReuseIdentifier: PostViewCell.id)
        self.postTableView.dataSource = self
        self.postTableView.delegate = self
        self.postTableView.separatorStyle = .none
        
        self.postTableView.backgroundColor = .systemGray5
        
        Task { await datastore.changeSync() }
    }

    @IBAction func addPost(_ sender: UIButton) {
        
        performSegue(withIdentifier: "GoToAddPost", sender: self)
    }
    
    func deletePost(post: Post) {
        print("Deleting row")
    }
    
    func editPost(post: Post) {
        print("Editing row")
    }
    
    func refreshTable() {
        self.postTableView.beginUpdates()
        self.postTableView.endUpdates()
    }
}

//MARK: - UITableViewDataSource Management
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostViewCell.id, for: indexPath) as! PostViewCell
        cell.setPost(post: self.postList[indexPath.row])
        
        cell.lblTitle.text = "example"
        cell.lblContent.text = "example"
        cell.lblRating.text = "example"
        
        return cell
    }
}

//MARK: - UITableViewDelegate Management
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete Post") {  (contextualAction, view, boolValue) in
            self.deletePost(post: self.postList[indexPath.row])
        }
        
        let editItem = UIContextualAction(style: .normal, title: "Edit Post") { (contextualAction, view, boolValue) in
            self.editPost(post: self.postList[indexPath.row])
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [editItem, deleteItem])
        return swipeActions
    }
}
