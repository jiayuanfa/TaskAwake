//
//  AppDelegate.swift
//  TaskAwoke
//
//  Created by JiaYuanFa on 16/7/18.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataModel:DataModel?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // App 启动的时候 获取DataModel 传递AllListTVC
        initListsDataList()
        
        // 设置本地推送
        let uns = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(uns)
        return true
}
    
    func initListsDataList(){
        dataModel = DataModel()
        let navigationController = self.window?.rootViewController as! UINavigationController
        let allListsController = navigationController.viewControllers.first as! AllListTableViewController
        allListsController.listsDataModel = dataModel!
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveListsData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveListsData()
    }
    
    
    //MARK:防止应用引入后台  或者引用终止 造成数据丢失 我们来写一个保存数据的方法
    func saveListsData(){
        
        // 保存数据
        dataModel!.savaListsData()
    }


}

