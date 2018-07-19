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
    
    private func underlined(textfield: UITextField){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width:  textfield.frame.size.width, height: textfield.frame.size.height)
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        underlined(textfield: email)
        underlined(textfield: password)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
