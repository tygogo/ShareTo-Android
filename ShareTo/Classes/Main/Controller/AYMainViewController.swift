//
//  AYMainViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import Alamofire

let topBarHeight:CGFloat = 40

class AYMainViewController: AYBaseViewController,UIScrollViewDelegate,TopVarViewDelegate {
    var needLogin:Bool = false;
    
    var current_page:Int = 0
    
    //top View
    lazy var topbar:AYTopTabView = {
        let frame = CGRectMake(0, 64, self.view.frame.size.width, topBarHeight)
        let topbar = AYTopTabView(frame: frame)
        topbar.bardelegate = self
        return topbar
    }()
    
    //main View
    lazy var mainView:UIScrollView = {
        let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        var scrollView:UIScrollView = UIScrollView(frame: frame)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height - 64 - 44 - topBarHeight)
        scrollView.contentInset = UIEdgeInsetsMake(64 + topBarHeight , 0, 49, 0)
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    var categories:NSArray?{
        didSet{
            //设置tab
            topbar.tabs = categories
            //设置下面部分
            var vc:AYPageListController
            var view:UIView
            let count = categories?.count
            for(var i:Int = 0 ;i < count; i++){
                vc = AYPageListController()
                vc.categoryName = categories?.objectAtIndex(i) as? String
                view = vc.view
                view.frame = CGRectMake(CGFloat.init(i) * mainView.frame.size.width, 0, mainView.frame.size.width, mainView.frame.size.height)
                self.addChildViewController(vc)
                self.mainView.addSubview(view)
//                if i == 0{
//                    self.mainView.addSubview(view)
//                }
            }
            mainView.contentSize = CGSizeMake(CGFloat.init(count!) * mainView.frame.size.width, 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "分享兔"
        self.tabBarItem.title = "首页"
        firstLoad()
        self.view.addSubview(self.mainView)
        self.view.addSubview(self.topbar)
        let back = UIBarButtonItem()
        back.title = ""
        self.navigationItem.backBarButtonItem = back
//        self.automaticallyAdjustsScrollViewInsets = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        //add btn
        let barButton = UIBarButtonItem(image: UIImage(named: "sendPost")?.imageWithRenderingMode(.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: "sendPost:")
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    
    
    func firstLoad(){
        if(self.needLogin){
            let ud = NSUserDefaults.standardUserDefaults()
            if let username = ud.objectForKey("username") as! String?{
                if let password = ud.objectForKey("password") as! String?{
                    Alamofire.request(.POST, "http://115.28.49.92:8082/port/login_port.ashx", parameters: ["user_id": username,
                        "user_password":password
                        ]).responseJSON { (response) -> Void in
                            switch response.result{
                            case .Success(let data):
                                if let j = data as? NSDictionary{
                                    if let success = j["LoginSuccess"] as! String?{
                                        if "success" == success{
                                            self.loadCategory()
                                        }else{
                                            self.logout()
                                        }
                                    }
                                }
                            case .Failure(_):
                                self.logout()
                                break

                            }
                    }
                    
                }
            }
        }else{
            loadCategory()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
//        loadCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCategory(){
        showProgress(self.view, text: "拼命加载中")
        Alamofire.request(.GET, "http://115.28.49.92:8082/port/get_category_port.ashx").responseJSON { (response) -> Void in
            self.hideAllMBProgressInView(self.view)
            switch response.result{
            case .Success(let json):
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let array = json.allObjects
                    var a = Array<String>()
                    for category in array{
                        a.append((category["category"] as! String?)!)
                    }
                    a.insert("最新", atIndex: 0)
                    self.categories = a
                })
            case .Failure(_):
                self.textShow(self.view, text: "加载失败")
            }
        
        }
    }
    //MARK: scrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = Int.init((scrollView.contentOffset.x / scrollView.frame.size.width))
        if(page != current_page){
            topbar.slectAtIndex(page)
            current_page = page
        }

    }
    
    //MARK: topViewDelegate
    func didSelectedPage(index: Int) {
        let offset = mainView.frame.size.width * CGFloat.init(index)
        self.mainView.setContentOffset(CGPointMake(offset, mainView.contentOffset.y), animated: true)
    }
    
    //MARK: slecter
    
    func sendPost(sender:UIBarButtonItem){
        let vc = AYSendPostViewController()
        if let array = categories{
            let arrayM = NSMutableArray(array: array)
            arrayM.removeObjectAtIndex(0)
            vc.categories = arrayM.copy() as! NSArray
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }

}
