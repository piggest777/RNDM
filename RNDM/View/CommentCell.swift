//
//  CommentCell.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-05-26.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

class CommentCell: UITableViewCell {

//    Outlets
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var optionsMenu: UIImageView!
    @IBOutlet weak var commentTxtLbl: UILabel!
    
    
//    var
    var delegate: CommentDelegate?
    var comment: Comment!

    
    func configureCell (comment: Comment, delegate: CommentDelegate) {
        optionsMenu.isHidden = true
        usernameLbl.text = comment.username
        self.delegate = delegate
        self.comment = comment
       
        commentTxtLbl.text = comment.commentTxt! as String

        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone.current
        let timestamp = formatter.string(from: comment.timestamp)
        timestampLbl.text = timestamp
        
        if comment.userId == Auth.auth().currentUser?.uid{
            optionsMenu.isHidden = false
            optionsMenu.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentOptionsTapped))
            optionsMenu.addGestureRecognizer(tap)
        }
    }
    
    
    @objc func commentOptionsTapped(){
        delegate?.commentOptionsTapped(comment: comment)
    }



}
