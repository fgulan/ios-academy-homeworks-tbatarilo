//
//  ShowTableViewCell.swift
//  TVShow
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var showName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(show: Show){
        showName.text = show.title
    }

}
