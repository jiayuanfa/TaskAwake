//
//  MainItem.swift
//  TaskAwoke
//
//  Created by JiaYuanFa on 16/7/20.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

import UIKit

class MainItem: NSObject{
    
    var text:String = ""    //任务内容
    var checked:Bool    // 是否已经完成
    var awakeTime:NSDate    // 任务提醒时间
    var shouldRemind:Bool   // 是否提醒
    var itemID:Int  // 任务ID 每个任务是唯一的
    
    //MARK: 从Object解析出来
    init(coder aDecoder:NSCoder!){
        self.text = aDecoder.decodeObjectForKey("text") as! String
        self.checked = aDecoder.decodeObjectForKey("checked") as! Bool
        self.awakeTime = aDecoder.decodeObjectForKey("awakeTime") as! NSDate
        self.shouldRemind = aDecoder.decodeObjectForKey("shouldRemaid") as! Bool
        self.itemID = aDecoder.decodeObjectForKey("itemId") as! Int
    }
    
    //MARK: 编码成Object
    func encodeWithCoder(aCoder:NSCoder!) {
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(checked, forKey: "checked")
        aCoder.encodeObject(awakeTime, forKey: "awakeTime")
        aCoder.encodeObject(shouldRemind, forKey: "shouldRemaid")
        aCoder.encodeObject(itemID,forKey: "itemId")
    }
    
    init(text:String, checked:Bool,dueDate:NSDate,shouldRemind:Bool) {
        self.text = text
        self.checked = checked
        self.awakeTime = dueDate
        self.shouldRemind = shouldRemind
        self.itemID = DataModel.createTaskIdFunction()
    }
    
    func toggleChecked(){
        self.checked = !self.checked
    }
    
    func scheduleNotification(){
        if self.shouldRemind && (self.awakeTime.compare(NSDate())) != NSComparisonResult.OrderedAscending{
            print("哎！艾斯哟 有活要干了！哈哈")
            
            // 首先判断通知是否已经存在 如果存在则删除通知 重新判断
            let existingNotification = self.notificationForItemID() as UILocalNotification?
            if existingNotification != nil {
                UIApplication.sharedApplication().cancelLocalNotification(existingNotification!)
            }
            // 创建UILocalNotification来进行本地通知
            let localNotification = UILocalNotification()
            // 设置推送时间
            localNotification.fireDate = self.awakeTime
            // 设置时区
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            // 消息内容
            localNotification.alertBody = self.text
            // 推送声音
            localNotification.soundName = UILocalNotificationDefaultSoundName
            // itemId
            localNotification.userInfo = ["ItemID":self.itemID]
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
    
    //通过itemId获取本地通知
    func notificationForItemID() -> UILocalNotification? {
        let allNotification = UIApplication.sharedApplication().scheduledLocalNotifications
        for notification in allNotification! {
            var info = notification.userInfo as Dictionary?
            let number = info?["ItemID"] as! Int
            if number != 0 && number == self.itemID {
                return notification
            }
        }
        return nil
    }
    
    // 在析构函数中删除本地推送
    deinit{
        let exitNotification = self.notificationForItemID() as UILocalNotification?
        if exitNotification != nil {
            UIApplication.sharedApplication().cancelLocalNotification(exitNotification!)
        }
    }

}
