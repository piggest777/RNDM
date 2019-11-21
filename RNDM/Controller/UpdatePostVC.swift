//
//  UpdatePostVC.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-09-05.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

class UpdatePostVC: UIViewController {
    
    var thought: Thought!

    
    @IBOutlet weak var editText: UITextView!
    @IBOutlet weak var updatebutton: UIButton!
    
    override func viewDidLoad() {
        editText.layer.cornerRadius = 10
        updatebutton.layer.cornerRadius = 10
        editText.text = thought.thoughtTxt
    }
    
    @IBAction func upadteBtnTapped(_ sender: Any) {
        
        Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).updateData([THOUGHT_TXT : editText.text ?? ""]) { (error) in
            if let error = error {
                debugPrint("Unable to edit Post: \(error.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
    
}
