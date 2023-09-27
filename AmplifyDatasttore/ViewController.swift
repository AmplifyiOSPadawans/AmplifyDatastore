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
    
    var postList: [Post] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardViewCellNib: UINib = UINib(nibName: PostViewCell.nibName, bundle: Bundle(for: type(of: self)))
        self.postTableView.register(cardViewCellNib, forCellReuseIdentifier: PostViewCell.id)
        self.postTableView.dataSource = self
        self.postTableView.delegate = self
        self.postTableView.separatorStyle = .none
        
        self.postTableView.backgroundColor = .systemGray5
        
        Task { await datastore.changeSync() }
        
        Task {
            if let posts = await datastore.getPosts() {
                self.postList = posts
                refreshTable()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToAddPost") {
            let secondView = segue.destination as! AddPostViewController
            
            let object = sender as! [String: Any?]
            secondView.postTitle = object["title"] as? String
            secondView.content = object["content"] as? String
            secondView.rating = object["rating"] as? Int
            secondView.status = object["status"] as? Bool
        }
    }
    
    @IBAction func addPost(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToAddPost", sender: self)
    }
    
    func deletePost(post: Post) {
        print("Deleting row")
        
        Task { await datastore.deletePost(post: post) }
    }
    
    func editPost(post: Post) {
        print("Editing row")
        
        let sender: [String: Any?] = [
            "title": post.title,
            "content": post.content,
            "rating": post.rating,
            "status": post.status == .active ? true : false,
        ]
        self.performSegue(withIdentifier: "GoToAddPost", sender: sender)
    }
    
    func refreshTable() {
        self.postTableView.reloadData()
    }
    
    func showAlert(_ message: String) {
        let dialogMessage = UIAlertController(title: "Atention", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            dialogMessage.dismiss(animated: true)
        })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
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
