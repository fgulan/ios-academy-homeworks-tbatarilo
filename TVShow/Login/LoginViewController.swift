//
//  LoginViewController.swift
//  TVShow
//
//  Created by Infinum Student Academy on 11/07/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rememberMeButton: UIButton!
    
    // MARK: -Private-
    private var isChecked = false;
    private var user: User?
    private var loginUser: LoginData?
    
    @IBAction func changeState(_ sender: Any) {
        isChecked = !isChecked
        if isChecked {
            rememberMeButton.setImage(#imageLiteral(resourceName: "ic-checkbox-filled"), for: UIControlState())
        } else {
            rememberMeButton.setImage(#imageLiteral(resourceName: "ic-checkbox-empty"), for: UIControlState())
        }
    }
    
    @IBAction func LogInPushHome(_ sender: Any) {
        if areEmpty(email: emailField.text!, password: passwordField.text!) {
            SVProgressHUD.showError(withStatus: "Enter both parameters.")
            return
        }
        loginUser(email: emailField.text!, password: passwordField.text!)
    }
    
    @IBAction func createPushHome(_ sender: Any) {
        if areEmpty(email: emailField.text!, password: passwordField.text!) {
            SVProgressHUD.showError(withStatus: "Enter both parameters.")
            return
        }
        registerUser(email: emailField.text!, password: passwordField.text!)
    }
    
    func areEmpty(email: String, password: String) -> Bool {
        return email.isEmpty || password.isEmpty
    }
    
    func pushToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController =
            storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.loginUser = self.loginUser
        navigationController?.setViewControllers([homeViewController], animated:
            true)
    }
    
    func loginUser(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseJSON{ [weak self]
                response in
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let response):
                    guard let jsonDict = response as? Dictionary<String, Any> else {
                        return
                    }
                    
                    guard
                        let dataDict = jsonDict["data"],
                        let dataBinary = try? JSONSerialization.data(withJSONObject: dataDict) else {
                            return
                    }
                    
                    do {
                        let loginUser: LoginData = try JSONDecoder().decode(LoginData.self, from: dataBinary)
                        self?.loginUser = loginUser
                        self?.pushToHome()
                    } catch let error {
                        print("Serialization error: \(error)")
                    }
                    
                case .failure(let error):
                    let alert = UIAlertController(title: "Error!", message: "Something went wrong, check your email and password and try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    
                    print("LOGIN API failure: \(error)")
                }
        }
    }
    
    func registerUser(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request("https://api.infinum.academy/api/users",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] response in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let response):
                    
                    guard let jsonDict = response as? Dictionary<String, Any> else {
                        return
                    }
                    
                    guard
                        let dataDict = jsonDict["data"],
                        let dataBinary = try? JSONSerialization.data(withJSONObject: dataDict) else {
                            return
                    }
                    
                    do {
                        let user: User = try JSONDecoder().decode(User.self, from: dataBinary)
                        self?.user = user
                        self?.loginUser(email: email, password: password)
                    } catch let error {
                        print("Serialization error: \(error)")
                        SVProgressHUD.showError(withStatus: "Error occured during registration.")
                    }
                case .failure:
                    SVProgressHUD.showError(withStatus: "Error occured during registration.")
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
