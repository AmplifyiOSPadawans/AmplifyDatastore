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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func savePost(_ sender: Any) {
        Task {
            let response = await dataStore.addPost(post:
                                Post(
                                    title: txtFldTitle.text ?? "",
                                    status: switchEnabled.isOn ? .active : .inactive,
                                    rating: Int(txtFldRatingf.text ?? "") ?? 0,
                                    content: txtFldContent.text ?? ""))
            
            if response {
                print("Object saved")
            } else {
                print("Something went wrong")
            }
        }
        
    }
}
