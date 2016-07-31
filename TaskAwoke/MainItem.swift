//
//  MainItem.swift
//  TaskAwoke
//
//  Created by JiaYuanFa on 16/7/20.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

import UIKit

class MainItem: NSObject{
    
    var text:String = ""
    var checked:Bool
    var awakeTime:NSDate
    var shouldRemind:Bool
    
    //MARK: 从Object解析出来
    init(coder aDecoder:NSCoder!){
        self.text = aDecoder.decodeObjectForKey("text") as! String
        self.checked = aDecoder.decodeObjectForKey("checked") as! Bool
        self.awakeTime = aDecoder.decodeObjectForKey("awakeTime") as! NSDate
        self.shouldRemind = aDecoder.decodeObjectForKey("shouldRemaid") as! Bool
    }
    
    //MARK: 编码成Object
    func encodeWithCoder(aCoder:NSCoder!) {
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(checked, forKey: "checked")
        aCoder.encodeObject(awakeTime, forKey: "awakeTime")
        aCoder.encodeObject(shouldRemind, forKey: "shouldRemaid")
    }
    
    init(text:String, checked:Bool,dueDate:NSDate,shouldRemind:Bool) {
        self.text = text
        self.checked = checked
        self.awakeTime = dueDate
        self.shouldRemind = shouldRemind
    }
    
    func toggleChecked(){
        self.checked = !self.checked
    }

}
