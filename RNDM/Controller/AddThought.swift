//
//  AddThought.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-05-12.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

class AddThought: UIViewController, UITextViewDelegate {
    
    
    //Outlets
    @IBOutlet private weak var categorySegment: UISegmentedControl!
    @IBOutlet private weak var usernameTxt: UITextField!
    @IBOutlet private weak var thoughtTxt: UITextView!
    @IBOutlet private weak var postButton: UIButton!
    
    //Variables
    private var selectedCategory = ThoughtCategory.funny.rawValue
//    private var username: String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.layer.cornerRadius = 4
        thoughtTxt.layer.cornerRadius = 4
        thoughtTxt.text = "My random thought.."
        thoughtTxt.textColor = UIColor.lightGray
        thoughtTxt.delegate = self


    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        default:
            selectedCategory = ThoughtCategory.crazy.rawValue
        }
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        
//        if let name: String = Auth.auth().currentUser?.displayName {
//            username = name
//        } else {
//            username = "anounimus"
//        }
//
  
        guard  let thought  = thoughtTxt.text, let username = Auth.auth().currentUser?.displayName else {return}
        
    
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [
            CATEGORY : selectedCategory,
            NUM_COMMENTS : 0,
            NUM_LIKES : 0,
            THOUGHT_TXT: thought,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME : username,
            USER_ID : Auth.auth().currentUser?.uid ?? ""
        ]) { (err) in
            if let err = err {
                debugPrint("Error addinng document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
