//
//  AYFriendsViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/28.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import Alamofire

class AYFriendsViewController: AYBaseViewController,UITableViewDelegate,UITableViewDataSource,AYFriendDetailViewControllerDelegate {
    var users:NSMutableArray = NSMutableArray(){
        didSet{
            self.tableView.reloadData()
        }
    }
    var currentIndex:NSIndexPath?
    
//http://115.28.49.92:8082/port/friend_list_port.ashx
    lazy var tableView:UITableView! = {
        let tv:UITableView = UITableView()
        tv.frame = self.view.frame
        tv.delegate = self
        tv.dataSource = self
        tv.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
        tv.rowHeight = 60
        tv.headerView = XWRefreshNormalHeader(target: self, action: "loadFriend")
        tv.registerNib(UINib.init(nibName: "AYFriendTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.greenColor()
        // Do any additional setup after loading the view.
//        self.edgesForExtendedLayout = .None
//        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(self.tableView)
        
        loadFriend()
        
    }
    
    func loadFriend(){
        Alamofire.request(.GET, "http://115.28.49.92:8082/port/friend_list_port.ashx").responseJSON { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let json = data as? NSDictionary{
                    if let result = json["Exist"] as? String{
                        
                        let arrayM = NSMutableArray()
                        if result == "true"{
                            if let users = json["UserInfo"] as? NSArray{
                                let count = users.count
                                for var i:Int = 0 ; i < count; i++ {
                                    if let dict = users.objectAtIndex(i) as? NSDictionary{
                                        let user = AYUser.init(dict: dict)
                                        arrayM.addObject(user)
                                    }
                                }
                            }
                        }
                        self.users = arrayM
                    }
                }
            case .Failure(_):
                self.textShow(self.view, text: "加载失败")
            }
        }
        self.tableView.headerView?.endRefreshing()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - TableViewDelegate && DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AYFriendTableViewCell
        let user = self.users[indexPath.row] as! AYUser
        cell.avatarImage.sd_setImageWithURL(NSURL.init(string: user.avatar_url))
        cell.nameLabel.text = user.name
        cell.bioLabel.text = user.bio
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentIndex = indexPath;
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let user = self.users[indexPath.row] as! AYUser
        let vc = AYFriendDetailViewController()
        vc.userId = user.id
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //delegate如果从详细界面删除了好友
    func delete(){
        if let i = currentIndex{
            self.users.removeObjectAtIndex(i.row)
            self.tableView.deleteRowsAtIndexPaths([i], withRowAnimation: .Automatic)
        }
        
    }

    
    
}
