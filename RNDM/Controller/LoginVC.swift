//
//  LoginVC.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-05-25.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

//    Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createUserBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 10
        createUserBtn.layer.cornerRadius = 10
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        guard  let email = emailTxt.text,
                let password = passTxt.text
        else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                debugPrint("sign in error: \(error)")
            } else {
                print("sign in with email \(email) and pass \(password)")
                self.dismiss(animated: true, completion: nil)
            }
           
            
        }
    }
    
    @IBAction func createUserBtnPressed(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let createVC = storyboard.instantiateViewController(withIdentifier: "createVC") as! CreateUserVC
        present(createVC, animated: true, completion: nil)
    }
    
}
