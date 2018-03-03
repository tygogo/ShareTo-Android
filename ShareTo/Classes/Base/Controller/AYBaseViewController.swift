//
//  AYBaseViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

class AYBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logout(){
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey("username")
        ud.removeObjectForKey("password")
        let vc = AYLoginViewController(nibName: "AYLoginViewController", bundle: NSBundle.mainBundle())
        let delegate = UIApplication.sharedApplication().delegate
        delegate?.window!!.rootViewController = vc;
        delegate?.window!!.makeKeyAndVisible();
    }
    
    func login(){
        
    }
    //阻塞操作的alert
    func showProgress(view:UIView, text:String){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = text
    }
    //隐藏alert
    func hideAllMBProgressInView(view:UIView){
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
    }
    //显示文本alert
    func textShow(view:UIView, text:String){
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = text
        hud.userInteractionEnabled = false
//        hud.detailsLabelText = "这是详细信息内容，会很长很长呢"
        //延迟隐藏
        hud.hide(true, afterDelay: 1.5)
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
