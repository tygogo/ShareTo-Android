//
//  AYUnderLineField.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

class AYUnderLineField: UITextField {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor(white: 0.75, alpha: 1.0).CGColor)
        CGContextFillRect(context, CGRectMake(0, self.frame.size.height - 0.7, self.frame.size.width, 0.5))
    }

}
