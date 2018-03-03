//
//  AYTabBarController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

class AYTabBarController: UITabBarController,UITabBarControllerDelegate,AskDialogDelegate {
    var currentIndex:Int = 0;
    var ud:NSUserDefaults =  NSUserDefaults.standardUserDefaults();

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let barItem = UITabBarItem.appearance()
        barItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGrayColor()], forState: .Normal)
        barItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(red: 216 / 255.0, green: 110 / 255.0, blue: 96 / 255.0, alpha: 1.0)], forState: .Selected)
        //新浪配色UIColor.init(red: 253 / 255.0, green: 130 / 255.0, blue: 36 / 255.0, alpha: 1.0)
        
        self.tabBar.tintColor = UIColor.init(red: 216 / 255.0, green: 110 / 255.0, blue: 96 / 255.0, alpha: 0.8)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        let index = tabBarController.childViewControllers.indexOf(viewController)! as Int
        switch index{
        case 0:
            return true
        case 1:
            fallthrough
        case 2:
            if let _ = ud.valueForKey("username"){
                if let _ = ud.valueForKey("password"){
                    return true
                }
            }
            let askView = NSBundle.mainBundle().loadNibNamed("AYAskForLoginView", owner: self, options: nil).first as! AYAskForLoginView
            askView.frame = self.view.frame;
            askView.alpha = 0.0;
            askView.delegate = self
            self.view.addSubview(askView)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                askView.alpha = 1.0
                }, completion: nil)
            return false
        default:
            return true
        }
    }

    func didSlectLogin(view: AYAskForLoginView) {
        let vc = AYLoginViewController(nibName: "AYLoginViewController" , bundle:NSBundle.mainBundle() )
        presentViewController(vc, animated: false, completion: nil)
        
    }
    
    static func getMainVc(needLog:Bool = false)->AYTabBarController{
        let mainVc = AYMainViewController()
        mainVc.title = "发现"
        if(needLog){
            mainVc.needLogin = true;
        }
        mainVc.tabBarItem.image = UIImage(named: "tabbar_home")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        mainVc.tabBarItem.selectedImage = UIImage(named: "tabbar_home_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let mainNvc = AYNavController(rootViewController: mainVc)
        
        let msgVc = AYMessageViewController()
        msgVc.title = "消息"
        msgVc.tabBarItem.image = UIImage(named: "tabbar_message_center")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        msgVc.tabBarItem.selectedImage = UIImage(named: "tabbar_message_center_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let msgNvc = AYNavController(rootViewController: msgVc)
        
        let meVc = AYMeViewController()
        meVc.title = "我的"
        meVc.tabBarItem.image = UIImage(named: "tabbar_profile")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        meVc.tabBarItem.selectedImage = UIImage(named: "tabbar_profile_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let meNvc = AYNavController(rootViewController: meVc)
        
        let tabVc = AYTabBarController()
        tabVc.setViewControllers([mainNvc, msgNvc, meNvc], animated: false)
        return tabVc
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
