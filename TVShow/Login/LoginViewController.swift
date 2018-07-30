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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self](dataResponse: DataResponse<LoginData>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let loginUser):
                    self?.loginUser = loginUser
                    self?.pushToHome()
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.showAlert(alertMessage: "Something went wrong, check your email and password and try again")
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](dataResponse: DataResponse<User>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let user):
                    self?.user = user
                    self?.loginUser(email: email, password: password)
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.showAlert(alertMessage: "Error occured during registration")
                }
            }
    }
    
    private func showAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Alert", message:
            alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
}
