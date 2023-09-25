//
//  PostViewCell.swift
//  AmplifyDatasttore
//
//  Created by David Perez Espino on 22/09/23.
//

import UIKit

class PostViewCell: UITableViewCell {
    
    static let nibName  : String = "PostViewCell"
    static let id       : String = "PostViewCellId"

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.clipsToBounds = false
        cardView.layer.cornerRadius = 15
        cardView.backgroundColor = UIColor.white
    }

    func setPost(post: Post) {
        lblTitle.text = post.title
        lblContent.text = post.content?.maxLength(length: 43) ?? ""
        lblRating.text = "Rating: \(post.rating).0"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension String {
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:NSRange(location: 0,length: nsString.length > length ? length : nsString.length))
        }
        return  str
    }
}
