//
//  AYCommentViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/28.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import Alamofire


class AYCommentViewController: AYBaseViewController,UITableViewDelegate,UITableViewDataSource,MainCellDelegate {
    var currentPage:Int = 1
    var comments:NSMutableArray = NSMutableArray(){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    lazy var tableView:UITableView = {
        let tv:UITableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tv.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 44
        tv.separatorStyle = .None
        tv.allowsSelection = false
        tv.registerNib(UINib.init(nibName: "AYMainCommentTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "mainCommentCell")
        tv.registerNib(UINib.init(nibName: "AYChildCommentTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "childCommentCell")
        
        tv.headerView = XWRefreshNormalHeader(target: self, action: "loadComment")
        tv.footerView = XWRefreshAutoNormalFooter(target: self, action: "loadMore")

        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.tableView)
        loadComment()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadComment(){
        currentPage = 1
        Alamofire.request(.GET, "http://115.28.49.92:8082/port/my_messageboard_port.ashx?pager_number=1").responseJSON { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let array = data as? NSArray{
                    let comments = NSMutableArray()
                    for var j:Int = 0 ; j < array.count ; j++ {
                        if let json = array[j] as? NSDictionary{
                            if let messageId = json["MessageId"] as? Int , let messages = json["MessageInfo"] as? NSArray{
                                
                                let count = messages.count
                                if let dict = messages[0] as? NSDictionary{
                                    let comment = AYComment(dict: dict)
                                    comment.id = messageId
                                    let childArrayM = NSMutableArray()
                                    for var i:Int = 1 ; i < count ; i++ {
                                        if let childDict = messages[i] as? NSDictionary{
                                            let childComment = AYComment(dict: childDict)
                                            childArrayM.addObject(childComment)
                                        }
                                    }
                                    comment.childMessage = childArrayM
                                    comments.addObject(comment)
                                }
                                
                            }
                            
                        }
                    }
                    self.comments = comments
                }
            case .Failure(_):
                self.textShow(self.view, text: "加载出错")
            }

            self.tableView.headerView?.endRefreshing()
            self.tableView.footerView?.endRefreshing()

        }
    }
    
    func loadMore(){
        print("load more")
        Alamofire.request(.GET, "http://115.28.49.92:8082/port/my_messageboard_port.ashx?pager_number=\(currentPage + 1)").responseJSON { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let array = data as? NSArray{
                    let comments = NSMutableArray()
                    for var j:Int = 0 ; j < array.count ; j++ {
                        if let json = array[j] as? NSDictionary{
                            if let messageId = json["MessageId"] as? Int , let messages = json["MessageInfo"] as? NSArray{
                                
                                let count = messages.count
                                if let dict = messages[0] as? NSDictionary{
                                    let comment = AYComment(dict: dict)
                                    comment.id = messageId
                                    let childArrayM = NSMutableArray()
                                    for var i:Int = 1 ; i < count ; i++ {
                                        if let childDict = messages[i] as? NSDictionary{
                                            let childComment = AYComment(dict: childDict)
                                            childArrayM.addObject(childComment)
                                        }
                                    }
                                    comment.childMessage = childArrayM
                                    comments.addObject(comment)
                                }
                                
                            }
                            
                        }
                    }
                    self.currentPage += 1
                    
                    self.comments.addObjectsFromArray(comments as [AnyObject] )
                    self.tableView.reloadData()
                }
            case .Failure(_):
                self.textShow(self.view, text: "没有更多啦")

            }
            self.tableView.headerView?.endRefreshing()
            self.tableView.footerView?.endRefreshing()

        }

    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - TableViewDelegate && datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.comments.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let comment = self.comments[section] as! AYComment
        return comment.childMessage.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var comment = self.comments[indexPath.section] as! AYComment
        
        if(indexPath.row != 0){
            comment = comment.childMessage[indexPath.row - 1] as! AYComment
            let cell = tableView.dequeueReusableCellWithIdentifier("childCommentCell") as!
            AYChildCommentTableViewCell
            cell.comment = comment
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("mainCommentCell") as! AYMainCommentTableViewCell
            cell.comment = comment
            cell.delegate = self
            cell.commentButton.tag = indexPath.section
            cell.commentButton.addTarget(self, action: "jumptoReplyController:", forControlEvents: .TouchUpInside)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func jumptoReplyController(sender:UIButton){
        let vc = AYReplyViewController()
        if let comment = self.comments[sender.tag] as? AYComment{
            vc.isNewComment = false
            vc.commentId = comment.id
            vc.fromUserId = comment.fromUserId
            vc.commentToText = comment.text
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        }
        

    }
    
    func tapAvatar(id:NSInteger){
        let vc = AYFriendDetailViewController()
        vc.userId = id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
