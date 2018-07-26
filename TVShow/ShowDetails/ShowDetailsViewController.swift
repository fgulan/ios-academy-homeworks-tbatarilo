//
//  ShowDetailsViewController.swift
//  TVShow
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class ShowDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var numberOfEpisodes: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self 
            tableView.dataSource = self
        }
    }
    
    var token: String?
    var showId: String?
    
    private var episodes: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShowInfo()
        getEpisodes()
        setNumberOfEpisodes()
    }
    
    private func setNumberOfEpisodes() {
        numberOfEpisodes.text = "Episodes " + String(episodes.count)
    }
    
    private func getShowInfo(){
        let token: String = self.token!
        let headers = ["Authorization": token]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/" + showId!,
                     method: .get,
                     //                     parameters: parameter,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:
                DataResponse<ShowDetails>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let showDetails):
                    self?.titleLabel.text = showDetails.title
                    self?.descriptionLabel.text = showDetails.description
                case .failure:
                    print("Fail")
                }
                
        }
    }
    
    private func getEpisodes() {
        let token: String = self.token!
        let headers = ["Authorization": token]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/" + showId! + "/episodes",
                     method: .get,
                    parameters: nil,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:
                DataResponse<[Episode]>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let episodes):
                    self?.episodes = episodes
                    self?.tableView.reloadData()
                    self?.setNumberOfEpisodes()
                    for episode in episodes {
                        print(episode.title)
                    }
                case .failure(let error):
                    print(error)
                }
                
        }
    }

}

extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShowDetailsViewCell = tableView.dequeueReusableCell(
            withIdentifier: "ShowDetailsViewCell",
            for: indexPath
            ) as! ShowDetailsViewCell

        let episode = episodes[indexPath.row]
        cell.configureWith(episode: episode)

        return cell
    }
}

