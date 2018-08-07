//
//  EpisodeDetailsViewController.swift
//  TVShow
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var episode: Episode?
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        hideNavigationBar()
    }
    
    private func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func settingScreen() {
        episodeNameLabel.text = episode?.title
        episodeNumberLabel.text = "S" + (episode?.season)! + " Ep" + (episode?.episodeNumber)!
        descriptionLabel.text = episode?.description
        
        let url = URL(string: "https://api.infinum.academy" + episode!.imageUrl)
        episodeImageView.kf.setImage(with: url)
    }
    
    @IBAction func backButtonTapp(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func commentsButtonTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Comments", bundle: nil)
        let commentsViewController = storyboard.instantiateViewController(
            withIdentifier: "CommentsViewController"
            ) as! CommentsViewController
        
        commentsViewController.token = self.token
        commentsViewController.episodeId = episode?.id
        
        let navigationController = UINavigationController(rootViewController:
            commentsViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
}
