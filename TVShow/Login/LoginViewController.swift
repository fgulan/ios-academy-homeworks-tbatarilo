//
//  LoginViewController.swift
//  TVShow
//
//  Created by Infinum Student Academy on 11/07/2018.
//  Copyright © 2018 Tomislav Batarilo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    

    
    // MARK: -Private-
    private var isChecked = false;
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var rememberMe: UIButton!
    
    
    @IBAction func changeState(_ sender: Any) {
        isChecked = !isChecked
        
        if isChecked {
            rememberMe.setImage(#imageLiteral(resourceName: "ic-checkbox-filled"), for: UIControlState())
        } else {
            rememberMe.setImage(#imageLiteral(resourceName: "ic-checkbox-empty"), for: UIControlState())
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
