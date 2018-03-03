//
//  AYChildCommentTableViewCell.swift
//  ShareTo
//
//  Created by GoGo on 15/11/29.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

class AYChildCommentTableViewCell: UITableViewCell {
    var comment:AYComment?{
        didSet{
            let name:String = (comment?.fromUserName)!
            let text:String = (comment?.text)!
            
            let string = "\(name): \(text)"
            let atext = NSMutableAttributedString.init(string: string, attributes: [NSFontAttributeName:self.commentLabel.font,NSForegroundColorAttributeName: UIColor.init(red: 85 / 255.0, green: 85 / 255.0, blue: 85 / 255.0, alpha: 1.0)])
            
            atext.addAttributes([NSForegroundColorAttributeName:UIColor.init(red: 28 / 255.0, green: 87 / 255.0, blue: 150 / 255.0, alpha: 1.0)], range: NSMakeRange(0, name.characters.count + 1))
            
            self.commentLabel.attributedText = atext
        }
    }

    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
