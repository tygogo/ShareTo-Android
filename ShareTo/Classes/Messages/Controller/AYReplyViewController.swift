//
//  AYReplyViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/30.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import Alamofire



class AYReplyViewController: AYBaseViewController {
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var replyToLabel: UILabel!
    var comment:AYComment!
    
    var isNewComment:Bool!
    var commentToText:String!
    var commentId:Int!
    var fromUserId:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.textView.resignFirstResponder()
        self.replyToLabel.text = commentToText
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        self.textView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sendComment(sender: UIButton) {
        var dict:Dictionary<String,String>!
        if isNewComment == false{
            dict = ["type": "reply",
                "message_id":"\(commentId)",
                "friend_id":"\(fromUserId)",
                "message" : self.textView.text!]
        }else{
            dict = ["type": "leave",
                "friend_id":"\(fromUserId)",
                "message" : self.textView.text!]
        }
        
        Alamofire.request(.POST, "http://115.28.49.92:8082/port/leave_message_port.ashx", parameters: dict).responseJSON { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let json = data as? NSDictionary{
                    if let result = json["state"] as? String{
                        if result == "reply_success" || result == "leave_success"{
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                }
            case .Failure(_):
                break
            }
                self.textShow(self.view, text: "留言失败")
        }
    }
    

}
