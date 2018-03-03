//
//  AYPost.swift
//  ShareTo
//
//  Created by GoGo on 15/11/26.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

class AYPost: NSObject {
    var authorId:Int = -1
    var authorname:String = ""
    var avatarUrl:String = ""
    var postId:Int = -1
    var postTime:String = ""
    var PostTitle:String = ""
    var ClickCount:Int = 0
    var category:String = ""
    
    static func PostWithDict(dict:NSDictionary)->AYPost{
        let model = AYPost()
        
        if let x = dict["UserId"] as? Int?{
            model.authorId = x!
        }
        
        if let x = dict["UserName"] as? String?{
            model.authorname = x!
        }

        if let x = dict["UserHeadPicture"] as? String?{
            model.avatarUrl = x!
        }
        
        if let x = dict["PostTitle"] as? String?{
            model.PostTitle = x!
        }
        
        if let x = dict["PostId"] as? Int?{
            model.postId = x!
        }
        
        if let x = dict["PostTime"] as? String?{
            model.postTime = x!
        }
        
        if let x = dict["ClickNumber"] as? Int?{
            model.ClickCount = x!
        }
        //2015年11月5日18时1分3秒
        return model
    }
}
