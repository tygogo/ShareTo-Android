//
//  AYNavController.swift
//  ShareTo
//
//  Created by GoGo on 15/11/25.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

class AYNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bar = UINavigationBar.appearance();
        bar.barStyle = UIBarStyle.Default;
        bar.tintColor = UIColor.whiteColor();
//         Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController);
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
