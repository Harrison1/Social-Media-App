//
//  UChatTableViewCell.swift
//  U Chatter
//
//  Created by Harrison McGuire on 11/12/14.
//  Copyright (c) 2014 harrisonmcguire. All rights reserved.
//

import UIKit

class UChatTableViewCell: UITableViewCell {

    @IBOutlet var userName: UILabel! = UILabel()
    @IBOutlet var timestamp: UILabel! = UILabel()
    @IBOutlet var chatTextView: UITextView! = UITextView()
    @IBOutlet var profileImageView: UIImageView! = UIImageView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
