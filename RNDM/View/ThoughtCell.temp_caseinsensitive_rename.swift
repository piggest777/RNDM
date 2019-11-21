//
//  thoughtCell.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-05-14.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var usernameLbL: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var thoughtTxtLbl: UILabel!
    @IBOutlet weak var numLikesLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
