//
//  UpdateCommentVC.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-09-04.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

class UpdateCommentVC: UIViewController {

    //Outlets
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var updateBtn: UIButton!
    
//    var
    var commentData : (comment: Comment, thought: Thought)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTxt.layer.cornerRadius = 10
        updateBtn.layer.cornerRadius = 10
        commentTxt.text = commentData.comment.commentTxt
        
    }
    
    
    
    @IBAction func updateTapped(_ sender: Any) {
        
        Firestore.firestore().collection(THOUGHTS_REF).document(commentData.thought.documentId)
        .collection(COMMENTS_REF).document(commentData.comment.documentId)
            .updateData([COMMENT_TXT : commentTxt.text ?? ""]) { (error) in
                if let error = error {
                    debugPrint("Unable to upadate comment: \(error.localizedDescription)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
        }
        
    }
    
    


}
