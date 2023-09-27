//
//  AddPostViewController.swift
//  AmplifyDatasttore
//
//  Created by David Perez Espino on 25/09/23.
//

import UIKit

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var txtFldTitle: UITextField!
    @IBOutlet weak var txtFldContent: UITextField!
    @IBOutlet weak var txtFldRatingf: UITextField!
    @IBOutlet weak var switchEnabled: UISwitch!
    
    var dataStore = DataStoreHelper()
    
    var postTitle: String?
    var content: String?
    var rating: Int?
    var status: Bool?
    
    var isUserEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if
            let postTitle = self.postTitle,
            let content = self.content,
            let rating = self.rating,
            let status = self.status {
            
            
            isUserEditing = true
            txtFldTitle.text = postTitle
            switchEnabled.isOn = status
            txtFldRatingf.text = String(rating)
            txtFldContent.text = content
        }
        
    }
    
    @IBAction func savePost(_ sender: Any) {
        
        if isUserEditing {
            Task {
                let response = await dataStore.updatePost(existingPost:
                                                        Post(
                                                            title: txtFldTitle.text ?? "",
                                                            status: switchEnabled.isOn ? .active : .inactive,
                                                            rating: Int(txtFldRatingf.text ?? "") ?? 0,
                                                            content: txtFldContent.text ?? ""))
                
                if response {
                    showAlert("Object updated")
                } else {
                    showAlert("Something went wrong")
                }
            }
        } else {
            Task {
                let response = await dataStore.addPost(post:
                                                        Post(
                                                            title: txtFldTitle.text ?? "",
                                                            status: switchEnabled.isOn ? .active : .inactive,
                                                            rating: Int(txtFldRatingf.text ?? "") ?? 0,
                                                            content: txtFldContent.text ?? ""))
                
                if response {
                    showAlert("Object saved")
                } else {
                    showAlert("Something went wrong")
                }
            }
        }
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
