//
//  AYTopTabView.swift
//  ShareTo
//
//  Created by GoGo on 15/11/26.
//  Copyright © 2015年 GoGo. All rights reserved.
//

import UIKit

let bar_height:CGFloat = 40

protocol TopVarViewDelegate{
    func didSelectedPage(index:Int)
}

class AYTopTabView: UIScrollView {
    var bardelegate:TopVarViewDelegate?
    
    
    var current_index:Int?{
        didSet{
            if let index = current_index{
                let button = buttons[index] as! UIButton
                let offset = button.frame.origin.x
                //less than half
                if index != 0{
                    self.setContentOffset(CGPointMake(
                        offset - button.frame.size.width,
                        0),
                        animated: true)
                }else{
                    self.setContentOffset(CGPointMake(
                        0,
                        0),
                        animated: true)
                }
//                if offset % self.frame.size.width > self.frame.size.width / 2{
////                    self.setContentOffset(CGPointMake(
////                        offset - self.frame.size.width / 2,
////                        0),
////                        animated: true)
//                    self.setContentOffset(CGPointMake(
//                        offset,
//                        0),
//                        animated: true)
//                }else{
//                    self.setContentOffset(CGPointMake(
//                        offset,
//                        0),
//                        animated: true)
//
//                }
            }
        }
    }
    
    var buttons:NSMutableArray = NSMutableArray()
    
    var tabs:NSArray?{
        didSet{
            var sumWidth:CGFloat = 0
            let normalColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
            let slectedColor = UIColor(red: 216/255, green: 110/255, blue: 96/255, alpha: 1.0)
            buttons.removeAllObjects()
            for var i:Int=0; i<self.tabs?.count; i++ {
                if let item = self.tabs?[i] as! String?{
                    let button = UIButton()
                    button.selected = (i == 0)
                    button.setTitle(item, forState: .Normal)
                    button.setTitleColor(normalColor, forState: .Normal)
                    button.setTitleColor(slectedColor, forState: .Selected)
                    button.titleLabel?.font = UIFont.systemFontOfSize(13)
                    button.sizeToFit()
                    button.frame = CGRectMake(sumWidth, 0, button.frame.size.width + 30, topBarHeight);
                    button.tag = i
                    button.addTarget(self, action: "buttonTaped:", forControlEvents: .TouchUpInside)
                    buttons.addObject(button)
                    
                    sumWidth = sumWidth + button.frame.size.width;
                    //                    mainView.addSubview(button)
                    //                    print(self.mainView.contentInset)
                    //                    print(self.categoryView.contentInset)
                    
                    self.addSubview(button)
                }
            }
            self.contentSize = CGSizeMake(sumWidth
                , 30);
            current_index = 0

        }
    }
    
    func slectAtIndex(index:Int){
        (buttons[current_index!] as! UIButton).selected = false
        (buttons[index] as! UIButton).selected = true
        current_index = index
    }
    
    func buttonTaped(button:UIButton){
        slectAtIndex(button.tag)
        self.bardelegate?.didSelectedPage(button.tag)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height)
        self.backgroundColor = UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1.0)
        self.showsHorizontalScrollIndicator = false
        self.bounces = true
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
