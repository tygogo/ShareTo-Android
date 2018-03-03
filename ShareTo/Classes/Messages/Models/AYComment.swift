//
//  AYComment.swift
//  ShareTo
//
//  Created by GoGo on 15/11/29.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

class AYComment: NSObject {
    var id:Int = -1 // setting by you
    var fromUserId:Int = -1
    var toUserId:Int = -1
    var fromUserName:String = ""
    var toUserName:String = ""
    var avatarUrl:String = ""
    var text:String = ""
    var date:String = ""
    var childMessage:NSArray = NSArray() // setting by you
    
    init(dict:NSDictionary) {
        if let x = dict["FromId"] as? Int{
            fromUserId = x
        }
        
        if let x = dict["ToId"] as? Int{
            toUserId = x
        }
        
        if let x = dict["FromName"] as? String{
            fromUserName = x
        }
        
        if let x = dict["ToName"] as? String{
            toUserName = x
        }
        
        if let x = dict["FromHeadPicturePath"] as? String{
            avatarUrl = x
        }
        
        if let x = dict["Message"] as? String{
            text = x
        }
        
        if let x = dict["Time"] as? String{
            date = x
        }

    }
    
    
    
    
}
