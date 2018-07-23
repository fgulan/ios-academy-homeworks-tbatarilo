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
    private var enteredEmail: String = ""
    private var enteredPassword: String = ""
    
    
    @IBAction func changeState(_ sender: Any) {
        isChecked = !isChecked
        
        if isChecked {
            rememberMeButton.setImage(#imageLiteral(resourceName: "ic-checkbox-filled"), for: UIControlState())
        } else {
            rememberMeButton.setImage(#imageLiteral(resourceName: "ic-checkbox-empty"), for: UIControlState())
        }
        
    }
    
    @IBAction func LogInPushHome(_ sender: Any) {
        enteredEmail = emailField.text!
        enteredPassword = passwordField.text!
        
        if areEmpty(email: emailField.text!, password: passwordField.text!) {
            SVProgressHUD.showError(withStatus: "Enter both parameters.")
            return
        }
        
         loginUser(email: emailField.text!, password: passwordField.text!)
    }
    
    @IBAction func createPushHome(_ sender: Any) {
        enteredEmail = emailField.text!
        enteredPassword = passwordField.text!
        
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
            storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(homeViewController, animated:
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
            .responseJSON{
                response in
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success:
                    self.pushToHome()
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Error occured during logging in. Try creating new account.")
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<User>) in
                switch response.result {
                case .success(let user):
                    print("Success: \(user)")
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "User is registered.")
                    self.loginUser(email: email, password: password)
                case .failure(let error):
                    print("API failure: \(error)")
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "Error occured during registration.")
                }
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
