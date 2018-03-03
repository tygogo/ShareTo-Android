//
//  AYMainCommentTableViewCell.swift
//  ShareTo
//
//  Created by GoGo on 15/11/29.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

protocol MainCellDelegate{
    func tapAvatar(id:NSInteger)
}

class AYMainCommentTableViewCell: UITableViewCell {
    var delegate:MainCellDelegate?
    var comment:AYComment?{
        didSet{
            let text:String = (comment?.text)!
            let fromName:String = (comment?.fromUserName)!
            let date:String = (comment?.date)!
            let toName:String = (comment?.toUserName)!
            let avatarUrl:String = (comment?.avatarUrl)!
            
            let commentString = "\(fromName) 给 \(toName) 留言"
            
            let atextM = NSMutableAttributedString.init(string: commentString, attributes: [NSFontAttributeName:self.nameLabel.font,NSForegroundColorAttributeName:UIColor.init(red: 85 / 255.0, green: 85 / 255.0, blue: 85 / 255.0, alpha: 1.0)])
            
            let nameColor = UIColor.init(red: 28 / 255.0, green: 87 / 255.0, blue: 150 / 255.0, alpha: 1.0)

            
            atextM.addAttributes([NSForegroundColorAttributeName:nameColor], range: NSMakeRange(0, "\(fromName)".characters.count))
            
            atextM.addAttributes([NSForegroundColorAttributeName:nameColor], range: NSMakeRange("\(fromName) 给 ".characters.count, "\(toName)".characters.count))
            
            
            self.nameLabel.attributedText = atextM
            self.mainTextLabel?.text = text
            self.dateLabel.text = date
            self.avatarImage.sd_setImageWithURL(NSURL.init(string: avatarUrl))
            
            let tap = UITapGestureRecognizer.init(target: self, action: "tap")
            self.avatarImage.userInteractionEnabled = true
            self.avatarImage.addGestureRecognizer(tap)
            
            if fromName == "我"{
                commentButton.hidden = true
            }else{
                commentButton.hidden = false
            }
            
        }
    }
    
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    override func didMoveToWindow() {
        self.avatarImage.layer.cornerRadius = 20
        self.avatarImage.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tap(){
        if let c = self.comment{
            if let d = self.delegate{
                d.tapAvatar(c.fromUserId)
            }
        }
    }
    
}
