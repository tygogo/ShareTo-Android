//
//  AYFriendDetailViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/27.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import Alamofire
protocol AYFriendDetailViewControllerDelegate{
    func delete()
}

class AYFriendDetailViewController: AYBaseViewController {
    var userId:Int?{
        didSet{
            loadUser(userId!)
        }
    }
    var user:AYUser?
    var delegate:AYFriendDetailViewControllerDelegate?
    
    @IBOutlet weak var addressIcon: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var MessageButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        
        self.avatar.layer.cornerRadius = 60
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.borderColor = UIColor.init(white: 1.0, alpha: 0.98).CGColor
        self.avatar.layer.shadowOffset = CGSizeMake(5, 5
        )
        self.avatar.layer.shadowRadius = 5
        self.avatar.layer.borderWidth = 3
        
        self.followButton.layer.cornerRadius = 15
        self.followButton.layer.masksToBounds = true
        self.MessageButton.layer.cornerRadius = 15
        self.MessageButton.layer.masksToBounds = true
        
        self.bgImage.clipsToBounds = true
        self.followButton.addTarget(self, action: "followBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        MessageButton.addTarget(self, action: "gotoMessage:", forControlEvents: .TouchUpInside)
    }
    
    func gotoMessage(sender:UIButton){
        if user!.type == AYUserType.Me{
            
        }else{
            let vc = AYReplyViewController()
            vc.isNewComment = true
            vc.fromUserId = self.userId!
            vc.commentToText = "给ta留言"
            vc.hidesBottomBarWhenPushed = true
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //        self.navigationController?.navigationBar.translucent = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        
        self.navigationController?.navigationBar.setBackgroundImage(nil,forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = nil
//        self.navigationController?.navigationBar.translucent = true

    }
    
    func loadUser(user_id:Int){
        Alamofire.request(.GET, "http://115.28.49.92:8082/port/user_info_port.ashx?user_id=\(user_id)").responseJSON { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let json = data as? NSDictionary{
                    if (json["Exsit"] as! String) ==  "true"{
                        if let userDict  = json["UserInfo"] as! NSDictionary?{
                            let user = AYUser(dict: userDict)
                            self.setUserInfo(user)
                            self.user = user
                            self.userId = user.id
                        }
                    }else{
                        // TODO: user not exist
                    }
                }
            case .Failure(_):
                break
            }
        }
        
    }
    
    func setUserInfo(user:AYUser){
        if user.avatar_url != "http://115.28.49.92:8082/headpicture/default.jpg"{
            let url = NSURL.init(string: (user.avatar_url))
            self.bgImage.sd_setImageWithURL(url)
            self.avatar.sd_setImageWithURL(url)
        }

        self.bioLabel.text = user.bio
        self.nameLabel.text = user.name
        let addr = user.address
        if addr == ""{
            addressIcon.hidden = true
            self.addressLabel.text = ""
        }else{
            addressIcon.hidden = false
            self.addressLabel.text = user.address
        }
        

        switch user.type{
        case AYUserType.Me:
            self.followButton.hidden = true
            self.MessageButton.hidden = true
//            self.followButton.setTitle("编辑资料", forState: UIControlState.Normal)
//            self.MessageButton.setTitle("我不知道", forState: UIControlState.Normal)
            break
        case AYUserType.NotFriend:
            self.followButton.hidden = false
            self.MessageButton.hidden = false

            self.followButton.setTitle("添加好友", forState: UIControlState.Normal)
            self.MessageButton.setTitle("马上留言", forState: UIControlState.Normal)
            break
        case AYUserType.Friend:
            self.followButton.hidden = false
            self.MessageButton.hidden = false

            self.followButton.setTitle("移除好友", forState: UIControlState.Normal)
            self.MessageButton.setTitle("马上留言", forState: UIControlState.Normal)
            break
        }
        

    }
    
    func followBtnClick(sender:UIButton){
        if let u = user{
            switch u.type{
            case AYUserType.NotFriend:
                sendFriendRequest(u.id)
                break
            case AYUserType.Friend:
                let ac = UIAlertController.init(title: "真的吗", message: "真的要移除ta吗?", preferredStyle: .Alert)
                let ok = UIAlertAction.init(title: "确定", style: .Destructive, handler: { (_) -> Void in
                    self.deleteFriendRequest(u.id)
                })
                ac.addAction(ok)
                
                let cancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
                
                
                ac.addAction(cancel)
                
                self.presentViewController(ac, animated: true, completion: nil)
                
                break
            case AYUserType.Me:
                let vc = AYModifyViewController()
                self.presentViewController(vc, animated: true, completion: nil)
                break
            }
        }
    }
    
    func sendFriendRequest(id:Int){
        Alamofire.request(.POST, "http://115.28.49.92:8082/port/send_confirm_message_port.ashx", parameters: ["confirm_id":"\(id)"]).responseString { (response) -> Void in
            switch response.result{
            case .Success(let result):
                if result == "success"{
                    //success
                    self.textShow(self.view, text: "已成功发送好友邀请,等待对方同意")
                    return
                }
            case .Failure(_):
                break
            }
            self.textShow(self.view, text: "添加失败,我也不知道为什么")
        }
    }
    
    func deleteFriendRequest(id:Int){
        Alamofire.request(.POST, "http://115.28.49.92:8082/port/delete_friend_port.ashx", parameters: ["friend_id":"\(id)"]).responseJSON { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let json = data as? NSDictionary{
                    if let result = json["delete"] as? String{
                        if result == "success"{
                            self.textShow(self.view, text: "删除成功啦!")
                            self.followButton.setTitle("添加好友", forState: UIControlState.Normal)
                            self.user?.type = .NotFriend
                            self.delegate?.delete()
                            return
                        }
                    }
                }
            case .Failure(_):
                break
            }
            //wrong
            self.textShow(self.view, text: "删除失败,我也不知道为什么")
        }
    }
    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
