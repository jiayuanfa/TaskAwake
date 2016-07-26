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
    
    //MARK: 从Object解析出来
    init(coder aDecoder:NSCoder!){
        self.text = aDecoder.decodeObjectForKey("text") as! String
        self.checked = aDecoder.decodeObjectForKey("checked") as! Bool
    }
    
    //MARK: 编码成Object
    func encodeWithCoder(aCoder:NSCoder!) {
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(checked, forKey: "checked")
    }
    
    init(text:String, checked:Bool) {
        self.text = text
        self.checked = checked
    }
    
    func toggleChecked(){
        self.checked = !self.checked
    }

}
