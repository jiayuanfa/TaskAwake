//
//  CheckList.swift
//  TaskAwoke
//
//  Created by JiaYuanFa on 16/7/23.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

import UIKit

class CheckList: NSObject,NSCoding {
    
    var name:String = ""
    var iconName:String = ""
    var mainItems = [MainItem]()
    
    init(name:String) {
        self.name = name
    }
    
        
    //MARK:计算还有多少任务需要去完成
    func countUnCheckItems() -> Int {
        var count = 0
        for item in mainItems {
            if item.checked != true {
                count += 1
            }
        }
        return count
    }
    
    //编码 解码
    //从 NSObject解析回来
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.iconName = aDecoder.decodeObjectForKey("iconName") as! String
        self.mainItems = aDecoder.decodeObjectForKey("mainItems") as! [MainItem]
    }
    
    // 编码成NSObject
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name,forKey: "name")
        aCoder.encodeObject(iconName,forKey: "iconName")
        aCoder.encodeObject(mainItems,forKey: "mainItems") 
    }
    
//    init(name:String) {
//        self.name = name
//    }
}
