//
//  AYSendPostViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/28.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import Alamofire

class AYSendPostViewController: AYBaseViewController,TopVarViewDelegate {
    var categories:NSArray?
    var sletedCategory:String?

    @IBOutlet weak var placeview: UIView!
    @IBOutlet weak var titleField: AYUnderLineField!
    
    @IBOutlet weak var mainTextView: UITextView!
    
    lazy var categoryView:AYTopTabView! = {
        let categoryView:AYTopTabView = AYTopTabView()
        categoryView.frame = CGRectMake(0, 0, self.placeview.frame.width, self.placeview.frame.height)
        categoryView.bardelegate = self
        if let c = self.categories{
            
            categoryView.tabs = c
            self.sletedCategory = categoryView.tabs![categoryView.current_index!] as! String
        }
        self.placeview.addSubview(categoryView)
        return categoryView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.placeview.addSubview(self.categoryView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //关闭
    @IBAction func close(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //发送
    @IBAction func send(sender: UIBarButtonItem) {
        var message:String = ""
        if let title = self.titleField.text {
            if title != ""{
            
            }else{
                message += "标题 "
            }
        }
        
        if let text = self.mainTextView.text as! String?{
            if text != ""{
                
            }else{
                message += "内容 "
            }
        }
        
        //标题和内容都填写
        if message == ""{
            textShow(self.view, text: "biu发送！")
            let title = self.titleField.text!
            let text = self.mainTextView.text!

            self.send(title, text: text, category: self.sletedCategory!)
            return
        }
        
        message+="还没写呢"
        textShow(self.view, text: message)
    }
    
    func send(title:String, text:String, category:String){
        Alamofire.request(.POST, "http://115.28.49.92:8082/port/edit_post_port.ashx", parameters:
            [
                "post_title": title,
                "post": text,
                "category": category
            ]
            ).responseJSON { (response) -> Void in
            //
                switch response.result{
                case .Success(let data):
                    if let json = data as? NSDictionary{
                        if let result = json["post"] as! String?{
                            if result == "success"{
                                //yes!
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }else{
                                //faild
                                self.textShow(self.view, text: "发送失败")
                            }
                        }
                    }
                case .Failure(_):
                    self.textShow(self.view, text: "发送失败")

                }
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
    
    // MARK: - topbarDelegate
    func didSelectedPage(index: Int) {
        self.sletedCategory = self.categoryView.tabs![index] as? String
    }
        

}
