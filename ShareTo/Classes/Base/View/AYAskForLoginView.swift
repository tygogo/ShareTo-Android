//
//  AYAskForLoginView.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

protocol AskDialogDelegate{
    func didSlectLogin(view:AYAskForLoginView)
}

class AYAskForLoginView: UIControl {
    
    var delegate:AskDialogDelegate?

    @IBOutlet weak var bgView: UIControl!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToWindow() {
        bgView.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        cancelBtn.layer.borderColor = UIColor(red: 253 / 255.0, green: 130 / 255.0, blue: 36 / 255.0, alpha: 1.0).CGColor
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 12
        cancelBtn.layer.masksToBounds = true
        cancelBtn.setTitleColor(UIColor(red: 253 / 255.0, green: 130 / 255.0, blue: 36 / 255.0, alpha: 1.0), forState: .Normal)
        
        okBtn.backgroundColor = UIColor(red: 253 / 255.0, green: 130 / 255.0, blue: 36 / 255.0, alpha: 1.0)
        
        okBtn.layer.cornerRadius = 12
        okBtn.layer.masksToBounds = true
        okBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        dialogView.layer.cornerRadius = 5
        dialogView.layer.masksToBounds = true
        
        
        cancelBtn.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
        okBtn.addTarget(self, action: "login", forControlEvents: .TouchUpInside)
    }
    
    
    func dismiss(){
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alpha = 0.0
            }) { (bool) -> Void in
                self.removeFromSuperview()
        }
    }
    
    func cancel(){
        dismiss()
    }
    
    func login()
    {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alpha = 0.0
            }) { (bool) -> Void in
                self.removeFromSuperview()
                self.delegate?.didSlectLogin(self)
        }
        
        
    }

}
