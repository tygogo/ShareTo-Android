//
//  AYFriendTableViewCell.swift
//  ShareTo
//
//  Created by GoGo on 15/11/29.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

class AYFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func didMoveToWindow() {
        self.avatarImage.layer.cornerRadius = 15
        self.avatarImage.layer.masksToBounds = true
        
    }
    
}
