//
//  AYMeTableViewCell.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import SDWebImage
class AYMeTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var fileCountLabel: UILabel!
    @IBOutlet weak var friendCountLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    var user:AYUser? {
        didSet{
            nameLabel.text = user?.name
            if let bio = user?.bio{
                bioLabel.text =  "简介：" + bio
            }
            if let avatarUrl = user?.avatar_url{
                avatarImg.sd_setImageWithURL(NSURL(string: avatarUrl))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImg.layer.cornerRadius = avatarImg.frame.size.width / 2
        avatarImg.layer.masksToBounds = true
//        avatarImg.userInteractionEnabled = true
        // Initialization code
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, user: AYUser) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.user = user;
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
