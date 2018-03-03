//
//  AYMessageViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

class AYMessageViewController: UIViewController {
    var currentIndex:Int = 0;
    var commentVC:AYCommentViewController!
    var friendsVc:AYFriendsViewController!
    
    lazy var segCtr:UISegmentedControl! = {
        let sc:UISegmentedControl = UISegmentedControl(items: ["评论","好友"])
        sc.frame = CGRectMake(0, 0, 110, 30)
        sc.tintColor = UIColor.init(red: 216 / 255.0, green: 110 / 255.0, blue: 96 / 255.0, alpha: 1.0)
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: "segCtrValueChanged:", forControlEvents: .ValueChanged)
        return sc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hidesBottomBarWhenPushed = true
        self.commentVC = AYCommentViewController()
        self.friendsVc = AYFriendsViewController()
        
        self.addChildViewController(self.commentVC)
        self.addChildViewController(self.friendsVc)
        self.view.addSubview(self.commentVC.view)

        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.titleView = self.segCtr
        // Do any additional setup after loading the view.
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
    
    //MARK: - SgementController
    func segCtrValueChanged(sender:UISegmentedControl){
        let index = sender.selectedSegmentIndex
        if currentIndex == index{
            return
        }
        if index == 0{
            self.transitionFromViewController(self.friendsVc, toViewController: self.commentVC, duration: 0.2, options: .TransitionNone, animations: nil, completion: { (bool) -> Void in
                self.currentIndex = index
            })
        }else if index == 1{
            self.transitionFromViewController(self.commentVC, toViewController: self.friendsVc, duration: 0.2, options: .TransitionNone, animations: nil, completion: { (bool) -> Void in
                self.currentIndex = index
            })
        }
    }
    

}
