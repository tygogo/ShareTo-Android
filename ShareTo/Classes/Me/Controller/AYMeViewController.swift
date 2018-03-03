//
//  AYMeViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import Alamofire
class AYMeViewController: AYBaseViewController,UITableViewDelegate,UITableViewDataSource{
    var user:AYUser?{
        didSet{
            self.tableView .reloadData()
            
        }
    }
    var postCount:String = "0"
    var friendCount:String = "0"
    var fileCount:String = "0"
    
    lazy var tableView:UITableView = {
        var tv:UITableView = UITableView(frame: self.view.frame, style: .Grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 120
//        tv.backgroundColor = UIColor.whiteColor()
        tv.registerNib(UINib.init(nibName: "AYMeTableViewCell", bundle: nil), forCellReuseIdentifier: "me_cell")
        
        
        tv.registerClass(UITableViewCell.self, forCellReuseIdentifier: "default_cell")
        return tv
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setNavBar()

        Alamofire.request(.GET, "http://115.28.49.92:8082/port/my_info_port.ashx").responseJSON(completionHandler: { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let json = data as? NSDictionary {
                    let user = AYUser(dict: json)
                    self.user = user;
                }
            case .Failure(_):
                break
            }
        })
        
        
        Alamofire.request(.GET, "http://115.28.49.92:8082/port/get_count_port.ashx").responseJSON(completionHandler: { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let json = data as? NSDictionary {
                    if let x = json["PostCount"] as? String{
                        self.postCount = x
                    }
                    if let x = json["FriendCount"] as? String{
                        self.friendCount = x
                    }
                    if let x = json["FileCount"] as? String{
                        self.fileCount = x
                    }
                    self.tableView.reloadData()
                }
            case .Failure(_):
                break
            }
        })
        // Do any additional setup after loading the view.
    }
    
    
    func setNavBar(){
        let btn = UIBarButtonItem(title: "退出", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        btn.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.darkGrayColor()], forState: .Normal)
        self.navigationItem.rightBarButtonItem = btn
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("me_cell") as! AYMeTableViewCell;
            cell.selectionStyle = .None
            cell.fileCountLabel.text = "\(fileCount)"
            cell.postCountLabel.text = "\(postCount)"
            cell.friendCountLabel.text = "\(friendCount)"

            cell.user = self.user
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("default_cell")
            cell?.imageView?.image = UIImage.init(named: "tabbar_home")
            cell?.textLabel?.text = "我的收藏"
            cell?.accessoryType = .DisclosureIndicator
            cell?.selectionStyle = .Gray
            return cell!
        default:
            return tableView.dequeueReusableCellWithIdentifier("default_cell")!;
        }
        
    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 5;
        default:
            return 10;
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 120
        default:
            return 44
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section{
        case 0:
            gotoDetail()
            break
        default:
            break
        }
    }
    
    func gotoDetail(){
        let vc = AYFriendDetailViewController()
        vc.userId = self.user?.id
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
