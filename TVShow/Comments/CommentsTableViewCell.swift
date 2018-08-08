//
//  CommentsTableViewCell.swift
//  TVShow
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configureWith(comment: Comment, image: UIImage) {
        nameLabel.text = comment.userEmail
        commentLabel.text = comment.text
        commentImageView.image = image
    }

}
