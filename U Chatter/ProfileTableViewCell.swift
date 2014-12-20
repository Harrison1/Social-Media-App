//
//  ProfileTableViewCell.swift
//  U Chatter
//
//  Created by Harrison McGuire on 12/9/14.
//  Copyright (c) 2014 harrisonmcguire. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageCell: UIImageView!
    @IBOutlet var backgroundImageCell: UIImageView!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var age: UILabel!
    @IBOutlet var about: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
