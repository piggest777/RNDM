//
//  ThoughtCell.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-05-14.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

protocol ThoughtDelegate {
    func thoughtOptionsTapped(thought: Thought)
}

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var usernameLbL: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var thoughtTxtLbl: UILabel!
    @IBOutlet weak var numLikesLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    @IBOutlet weak var commentsNumberLbl: UILabel!
    @IBOutlet weak var commentsImg: UIImageView!
    @IBOutlet weak var optionsMenu: UIImageView!
    

    
    private var thought: Thought!
    private var delegate: ThoughtDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(  likeTapped ))
        likesImg.addGestureRecognizer(tap)
        likesImg.isUserInteractionEnabled = true
    }
    @objc func likeTapped () {
        Firestore.firestore().document("thoughts/\(thought.documentId!)")
        .updateData([NUM_LIKES : thought.numLikes + 1])
        
    }
    
    func configureCell(thought: Thought, delegate: ThoughtDelegate?) {
        
        optionsMenu.isHidden = true
        self.thought = thought
        self.delegate = delegate
        usernameLbL.text = thought.username

        thoughtTxtLbl.text = thought.thoughtTxt
        numLikesLbl.text = String(thought.numLikes)
        
        commentsNumberLbl.text = String(thought.numComments)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        let timestamp = formatter.string(from: thought.timestamp)
        timestampLbl.text = timestamp
        
        if thought.userId == Auth.auth().currentUser?.uid {
            optionsMenu.isHidden = false
            optionsMenu.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(thoughtOptionTapped))
            optionsMenu.addGestureRecognizer(tap)
            
           
        }
    }
    
    @objc func thoughtOptionTapped () {
        delegate?.thoughtOptionsTapped(thought: thought)
    }

}
