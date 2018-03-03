//
//  AYPageListController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/26.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage


class AYPageListController: AYBaseViewController, UITableViewDelegate,UITableViewDataSource {
    var categoryName:String?
    
    var posts:NSMutableArray = NSMutableArray()
    
    var currentPage:Int = 1
    
    var api = "http://115.28.49.92:8082/port/post_list_port.ashx?pager_number="
    
    var newest_api = "http://115.28.49.92:8082/port/post_list_port.ashx?pager_number="

    lazy var tableView:UITableView = {
        var tableView:UITableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 40 - 44), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 110
        tableView.headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData")
        tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")

        
        
        tableView.registerNib(UINib.init(nibName: "AYPostCellTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        loadData()

    }
    //下拉
    func upPullLoadData(){
        loadData()
    }
    //上拉
    func downPlullLoadData(){
        loadMore()
    }
    
    func loadData(){
        
        var url:String
        currentPage = 1
        if(categoryName == "最新"){
            url = newest_api + "1"
        }else{
            //TODO: category
//            self.tableView.headerView?.endRefreshing()
//            self.tableView.footerView?.endRefreshing()
//            return
            url = newest_api + "1&category=\(categoryName!)"
        }
        
        Alamofire.request(.GET, url).responseJSON(completionHandler: { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let json = data as? NSDictionary{
                    if let array = json.objectForKey("PostList") as! NSArray?{
                        var post:AYPost
                        let aM = NSMutableArray()
                        for var i:Int = 0 ; i < array.count; i++ {
                            let dict = array.objectAtIndex(i) as! NSDictionary
                            post = AYPost.PostWithDict(dict)
                            aM.addObject(post)
                        }
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.posts = aM;
                            self.tableView.reloadData()
                        })
                    }
                }
            case .Failure(_):
                self.textShow(self.view, text: "错啦")

            }
            self.tableView.headerView?.endRefreshing()
            self.tableView.footerView?.endRefreshing()
            
        })
    }
    
    func loadMore(){
        var url:String
        if(categoryName == "最新"){
            url = newest_api + "\(currentPage + 1)"
        }else{
            //TODO: 根据category
//            self.tableView.headerView?.endRefreshing()
//            self.tableView.footerView?.endRefreshing()
//            return
            url = newest_api + "\(currentPage + 1)&category=\(categoryName!)"
        }
        
        Alamofire.request(.GET, url).responseJSON(completionHandler: { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let json = data as? NSDictionary{
                    if let array = json.objectForKey("PostList") as! NSArray?{
                        if array.count == 0{
                            self.textShow(self.view, text: "没有更多啦")
                        }
                        var post:AYPost
                        let aM = NSMutableArray()
                        for var i:Int = 0 ; i < array.count; i++ {
                            let dict = array.objectAtIndex(i) as! NSDictionary
                            post = AYPost.PostWithDict(dict)
                            aM.addObject(post)
                        }
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.posts.addObjectsFromArray(aM as [AnyObject]);
                            self.tableView.reloadData()
                            self.currentPage =  self.currentPage + 1
                        })
                    }
                }
            case .Failure(_):
                self.textShow(self.view, text: "加载失败")
            }

            self.tableView.headerView?.endRefreshing()
            self.tableView.footerView?.endRefreshing()
        })

    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: tableviewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AYPostCellTableViewCell
        let model = self.posts[indexPath.row] as! AYPost
        cell.titleLabel.text = model.PostTitle
        cell.authorLabel.text = model.authorname
        cell.avatarLabel?.sd_setImageWithURL(NSURL(string: model.avatarUrl))
        cell.countLabel.text = "阅读：\(model.ClickCount)"
//        let date = model.postTime.characters.split{$0 == " "}
//        let date1 = date[0].split{$0 == "-"}// 年月日
//        let date2 = date[1].split{$0 == ":"}//时分秒
        cell.dateLabel.text = model.postTime
//        cell.dateLabel.text = "\(String.init(date1[1]))月\(String.init(date1[2])) \(String.init(date2[0])):\(String.init(date2[1]))"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let model = self.posts[indexPath.row] as! AYPost
        let vc = AYPageDetailViewController()
        vc.post_id = model.postId
        vc.hidesBottomBarWhenPushed = true
        vc.post = model
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
