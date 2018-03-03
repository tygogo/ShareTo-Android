//
//  AYLoginViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import Alamofire
class AYLoginViewController: AYBaseViewController {

    @IBOutlet weak var idField: AYUnderLineField!
    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var pwdField: AYUnderLineField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
    }
    
    func initView(){
        logBtn.layer.cornerRadius = 20
        logBtn.layer.masksToBounds = true
        
        idField.leftView = UIImageView(image: UIImage(named: "user_id"))
        idField.leftViewMode = .Always
        pwdField.leftView = UIImageView(image: UIImage(named: "user_pwd"))
        pwdField.leftViewMode = .Always
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
    
    @IBAction func reg(sender: UIButton) {
    }
    
    @IBAction func login(sender: UIButton) {
        if let username = idField.text{
            if let password = pwdField.text{
                Alamofire.request(.POST, "http://115.28.49.92:8082/port/login_port.ashx", parameters: ["user_id": username,
                    "user_password":password
                    ]).responseJSON { (response) -> Void in
                        switch response.result{
                        case .Success(let data):
                            if let j = data as? NSDictionary{
                                if let success = j["LoginSuccess"] as! String?{
                                    if "success" == success{
                                        let ud = NSUserDefaults.standardUserDefaults()
                                        ud.setValue(username, forKey: "username")
                                        ud.setValue(password, forKey: "password")
                                        let vc = AYTabBarController.getMainVc()
                                        let delegate = UIApplication.sharedApplication().delegate
                                        delegate?.window!!.rootViewController = vc;
                                        delegate?.window!!.makeKeyAndVisible();
                                    }else{
                                        self.textShow(self.view, text: "用户名或密码错误")
                                        //wrong
                                        self.pwdField.text = ""
                                        self.idField.text = ""
                                    }
                                }
                            }
                        case .Failure(_):
                            break
                        }
                }
            }else{
            //password empty
            self.textShow(self.view, text: "输密码吖")
            }
        }else{
            //id empty
            self.textShow(self.view, text: "输名字吖")
        }
        
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
