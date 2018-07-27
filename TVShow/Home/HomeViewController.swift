//
//  HomeViewController.swift
//  TVShow
//
//  Created by Infinum Student Academy on 19/07/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var _tableView: UITableView! {
        didSet {
            _tableView.delegate = self
            _tableView.dataSource = self
        }
    }
    
    var loginUser: LoginData?
    
    //MARK: -Private-
    private var listOfShows: [Show] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Shows"
        
        getShows()
    }

    
    private func getShows(){
        let headers = ["Authorization": loginUser!.token]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](dataResponse: DataResponse<[Show]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let shows):
                    self?.listOfShows = shows
                    self?._tableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }

}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShowTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "ShowTableViewCell",
            for: indexPath
            ) as! ShowTableViewCell
        
        let show = listOfShows[indexPath.row]
        cell.configureWith(show: show)
        
        return cell
    }
}
