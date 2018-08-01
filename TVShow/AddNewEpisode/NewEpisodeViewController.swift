//
//  NewEpisodeViewController.swift
//  TVShow
//
//  Created by Infinum Student Academy on 27/07/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Kingfisher

protocol Reloading {
    func shouldReload(episode: Episode)
}

class NewEpisodeViewController: UIViewController {

    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
    
    var showId: String?
    var token: String?
    var delegate: Reloading?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineCancelButton()
        navigationItem.title = "Add episode"
        defineAddButton()
    }
    
    private func defineCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectCancel))
    }
    
    private func defineAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action:    #selector(didSelectAddShow))
    }
    
    @objc func didSelectAddShow() {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId": showId!,
            "mediaId": "",
            "title": episodeTitleTextField.text!,
            "description": episodeDescriptionTextField.text!,
            "episodeNumber": episodeNumberTextField.text!,
            "season": seasonNumberTextField.text!
        ]
        
        let headers = ["Authorization": token!]
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers : headers
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:DataResponse<Episode>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let episode):
                    self?.delegate?.shouldReload(episode: episode)
                    self?.dismiss(animated: true)
                case .failure:
                    self?.showAlert(alertMessage: "Adding episode failed")
                }
        }
    }
    
    @objc func didSelectCancel() {
        self.dismiss(animated: false)
    }
    
    private func showAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Alert", message:
            alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
}
