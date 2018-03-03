//
//  AYUser.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
enum AYUserType{
    case Friend
    case NotFriend
    case Me
}
class AYUser: NSObject {
    var id:Int = 0
    var name:String = ""
    var bio:String = ""
    var avatar_url:String = ""
    var address:String = ""
    var type:AYUserType = .NotFriend

    init(dict:NSDictionary) {
        
        if let x = dict["Name"] as? String{
            name = x
        }
        if let x = dict["FriendName"] as? String{
            name = x
        }
        
        // TODO: bio
        if let x = dict["Mood"] as? String{
            bio = x
        }
        
        if let x = dict["Id"] as? Int{
            id = x
        }
        
        if let x = dict["Headpicturepath"] as? String{
            avatar_url = x
        }

        if let x = dict["Address"] as? String{
             address = x
        }
        
        if let x = dict["Type"] as? String{
            if x == "friend"{
                self.type = .Friend
            }else if x == "not_friend"{
                self.type = .NotFriend
            }else if x == "me"{
                self.type = .Me
            }
        }
        
    }
    
    override init() {
        super.init()
    }
    
}
