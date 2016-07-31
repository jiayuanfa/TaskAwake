//
//  DataModel.swift
//  TaskAwoke
//
//  Created by JiaYuanFa on 16/7/24.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    
    var lists = [CheckList]()
    
    
    override init() {
        super.init()
        loadCheckListItems()
        
        registerDefaults()
    }
    
    //MARK:对任务类型进行排序
    func sortCheckList() {
        lists.sortInPlace(onSort)
    }

    func onSort(s1:CheckList,s2:CheckList) -> Bool {
        return s1.name > s2.name
    }
    
    //MARK:程序初始安装的时候设置index为-1
    func registerDefaults() {
        let dictionary: Dictionary<String,Int> = ["checkListIndex":-1]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    //MARK:设置index的值
    func setIndexOfSelectedCheckList(index:Int){
        NSUserDefaults.standardUserDefaults().setInteger(index, forKey: "checkListIndex")
    }
    
    //MARK:获取index的值
    func getIndexOfCheckList() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("checkListIndex")
    }
    
    //MARK:保存本地数据
    func savaListsData(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData:data)
        archiver.encodeObject(lists, forKey: "checkLists")
        archiver.finishEncoding()
        data.writeToFile(filePath(), atomically: true)
    }
    
    //MARK:加载本地数据
    func loadCheckListItems(){
        let fileManager = NSFileManager()
        if fileManager.fileExistsAtPath(filePath()) {
            let data = NSData(contentsOfFile: filePath())
            let unarchiver = NSKeyedUnarchiver(forReadingWithData:data!)
            lists = unarchiver.decodeObjectForKey("checkLists") as! Array
            unarchiver.finishDecoding()
        }else{
            // 文件不存在 是第一次安装本应用 创建一个CheckList
            let checkList:CheckList! = CheckList(name:"第一个任务类型")
            lists.append(checkList)
            savaListsData()
        }
    }
    
    //MARK:获取沙盒文件路径
    func documentDirectory() ->String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectory = paths.first!
        return documentDirectory
    }
    
    //MARK:文件路径
    func filePath() -> String{
        return documentDirectory().stringByAppendingString("checkLists.plist")
    }
    
    //MARK:生成任务DI的方法
    class func createTaskIdFunction() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemId = userDefaults.integerForKey("checkListItemId")
        // +1保存
        userDefaults.setInteger(itemId+1, forKey: "checkListItemId")
        userDefaults.synchronize()
        return itemId
    }

}
