//
//  AYAuthorInfoBar.swift
//  ShareTo
//
//  Created by GoGo on 15/11/26.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

class AYAuthorInfoBar: UIView {
    var post:AYPost?{
        didSet{
            if post!.authorname == ""{
                self.authorLabel.text = "."
            }else{
                self.authorLabel.text = post!.authorname
            }
            self.avatarImage.sd_setImageWithURL(NSURL.init(string: post!.avatarUrl))
            self.dateLabel.text = post!.postTime
            self.readCountLabel.text = "阅读 \(post!.ClickCount)"
            self.titleLabel.text = post!.PostTitle
        }
    }
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorIconLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func didMoveToWindow() {
        avatarImage.layer.cornerRadius = 17.5
        avatarImage.layer.masksToBounds = true
        followButton.layer.cornerRadius = 2
        followButton.layer.masksToBounds = true
        
        
        
        authorIconLabel.layer.cornerRadius = 3
        authorIconLabel.layer.masksToBounds = true
        authorIconLabel.layer.borderWidth = 0.5
        authorIconLabel.layer.borderColor = UIColor(red: 216/255, green: 110/255, blue: 96/255, alpha: 1.0).CGColor
    }
}
