//
//  AYPageDetailViewController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/26.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit
import Alamofire

class AYPageDetailViewController: AYBaseViewController {
    let api = "http://115.28.49.92:8082/port/post_detail_port.ashx?post_id="
    var post:AYPost?
    var post_id:Int = -1
    lazy var scrollView:UIScrollView = {
        let scrollView:UIScrollView = UIScrollView(frame: self.view.frame)
        return scrollView
    }()
    
    lazy var textView:UITextView = {
        let textView:UITextView = UITextView(frame: CGRectMake(0, self.infoBar.frame.height, self.view.frame.size.width, 100))
        textView.font = UIFont.systemFontOfSize(15.5)
//        textView.font = UIFont.preferredFontForTextStyle(<#T##style: String##String#>)
//        textView.sizeToFit()
        textView.textContainerInset = UIEdgeInsetsMake(8,8,0,4)
        textView.scrollEnabled = false
        textView.editable = false
        return textView
    }()
//    lazy var webView:UIWebView = {
//        let webView:UIWebView = UIWebView
//    }()
    
    lazy var infoBar:AYAuthorInfoBar = {
        let infoBar:AYAuthorInfoBar = NSBundle.mainBundle().loadNibNamed("AYAuthorInfoBar", owner: self, options: nil).first as! AYAuthorInfoBar
        
        infoBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 140)
        if let p = self.post{
            infoBar.post = p
        }
        infoBar.followButton.addTarget(self, action: "gotoUserDetail", forControlEvents: .TouchUpInside)
        
        return infoBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = ""
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        self.navigationController
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.textView)
        self.scrollView.addSubview(self.infoBar)
        scrollView.contentSize = CGSizeMake(0, textView.frame.height)
        // Do any additional setup after loading the view.
        loadDetail()
    }
    
    // MARK: - Goto Detail
    func gotoUserDetail(){
        let vc = AYFriendDetailViewController()
        vc.userId = self.post?.authorId
        self.navigationController?.pushViewController(vc, animated: true)
    }


    func loadDetail(){
        showProgress(self.view, text:"拼命加载中")
        let url = "http://115.28.49.92:8082/port/post_detail_port.ashx?post_id=\(post_id)"
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            switch response.result{
            case .Success(let data):
                if let json = data as? NSDictionary{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let text = json["Post_Info"] as! String
                        self.setTextViewText(text)
                        self.infoBar.textCountLabel.text = "字数 \(text.characters.count)"
                        self.hideAllMBProgressInView(self.view)
                    })
                }
            case .Failure(_):
                self.hideAllMBProgressInView(self.view)
                self.textShow(self.view, text:"加载失败")

            }
        }
    }
    
    func setTextViewText(text:String){
//        self.textView.text = text
        let text2 = text.stringByAppendingString("<style>body{font-family: '\(self.textView.font!.fontName)'; font-size:\(self.textView.font!.pointSize)px;}</style>")
        
        let date = text2.dataUsingEncoding(NSUnicodeStringEncoding)
        do{
            let _ = try self.textView.attributedText = NSAttributedString(data: date!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
        }catch {
//            print("fail")
        }
        
        let xx = self.textView.sizeThatFits(CGSizeMake(textView.frame.size.width, CGFloat.max))
        self.textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.width, xx.height)
//        self.textView.backgroundColor = UIColor.redColor()
        self.scrollView.contentSize = CGSizeMake(0, xx.height + self.infoBar.frame.height)
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
