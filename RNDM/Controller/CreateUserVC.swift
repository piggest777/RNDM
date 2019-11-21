//
//  CreateUserVC.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-05-25.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateUserVC: UIViewController {

//    Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var createUserBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUserBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
    }
    
    @IBAction func createUserBtnPressed(_ sender: Any) {
        
        guard let email = emailTxt.text, let password = passTxt.text, let username = usernameTxt.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, err) in
            if let error = err {
                debugPrint(error)
            } else {
                let user = dataResult?.user
                let changeReqest = user?.createProfileChangeRequest()
                changeReqest?.displayName = username
                changeReqest?.commitChanges(completion: { (error) in
                    if let error = error{
                        debugPrint(error)
                    }
                })
                guard let userID = user?.uid else {return}
                Firestore.firestore().collection(USERS_REF).document(userID)
                    .setData([
                        USERNAME : username,
                        DATE_CREATED : FieldValue.serverTimestamp()
                        
                        ], completion: { (error) in
                        if let error = error {
                            debugPrint(error)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                            }
                    })
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
