//
//  ShowDetailsViewCell.swift
//  TVShow
//
//  Created by Infinum Student Academy on 27/07/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import UIKit

class ShowDetailsViewCell: UITableViewCell {

    @IBOutlet weak var episodePropertyLabel: UILabel!
    @IBOutlet weak var episodeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWith(episode: Episode){
        episodePropertyLabel.text = "S" + episode.season + " Ep" + episode.episodeNumber
        episodeNameLabel.text = episode.title
    }

}
