//
//  AllListTableViewController.swift
//  TaskAwoke
//
//  Created by JiaYuanFa on 16/7/23.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

// 所有任务类型类

import UIKit

class AllListTableViewController: UITableViewController,ListDetailTableViewDelegate,UINavigationControllerDelegate {
    
    //MARK:导航栏代理 导航栏即将推入自己VC 的时候记录index为-1
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController == self {
            listsDataModel!.setIndexOfSelectedCheckList(-1)
        }
    }
    
    
    //MARK:试图显示的时候取出index 判断上次退出是否停留在子界面 并设置代理
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
        let index = listsDataModel!.getIndexOfCheckList()
        if index > 0 && index < listsDataModel!.lists.count {
            let checkList = listsDataModel!.lists[index]
            self.performSegueWithIdentifier("showDetailList", sender: checkList)
        }
        
    }
    
    // 数据源
    var listsDataModel:DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listsDataModel!.loadCheckListItems()
        
        self.tableView.tableFooterView = UIView.init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listsDataModel!.lists.count
    }

    //MARK:初始化Cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier: cellIdentifier)
        }
        cell?.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        
        let checkList = listsDataModel!.lists[indexPath.row]
        
        //计算还有多少个任务需要提醒
        let count = checkList.countUnCheckItems()
        
        cell?.textLabel?.text = checkList.name
        
        if checkList.mainItems.count == 0 {
            cell!.detailTextLabel?.text = "还没有添加任务"
        }else{
            if count == 0 {
                cell!.detailTextLabel?.text = "全部搞定！"
            }else{
                cell!.detailTextLabel?.text = "还有\(count)件任务需要去搞定！"
            }
        }
        return cell!
    }
    
    //MARK:编辑Cell的跳转方法 传递数据给checkListToEdit
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        // 获取导航控制器
        let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("ListNavigationController") as! UINavigationController
        // 获取切换目标
        let controller = navigationController.topViewController as! ListDetailTableViewController
        // 设置代理
        controller.delegate = self
        // 获取选中数据
        let checklist = listsDataModel!.lists[indexPath.row]
        // 传递数据
        controller.checkListToEdit = checklist
        // 页面跳转
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    
    //MARK:选中Cell之后 传递checkList给详情页
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 存储checkListIndex
        listsDataModel?.setIndexOfSelectedCheckList(indexPath.row)
        
        let checkList = listsDataModel!.lists[indexPath.row]
        self.performSegueWithIdentifier("showDetailList", sender: checkList)
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            listsDataModel!.lists.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    //MARK: ListDetailVCDelegate
    func cancle() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:编辑完成 保存数据
    func editFinish(checkList: CheckList) {
        
        //排序
        listsDataModel!.sortCheckList()
        
        self.tableView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //保存数据
        listsDataModel!.savaListsData()
    }
    
    //MARK:添加数据完成 保存数据
    func addFinish(checkList: CheckList) {
        
        // 插入新数据
        let newRowIndex = listsDataModel!.lists.count
        listsDataModel!.lists.append(checkList)
        
        //排序
        listsDataModel!.sortCheckList()
        
        // 动画
        let indexPath = NSIndexPath(forRow: newRowIndex,inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        // dismiss
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // 保存数据
        listsDataModel!.savaListsData()
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */


    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailList" {
        
            let controllerVC = segue.destinationViewController as! MainController
            controllerVC.checkList = sender as? CheckList
            
        }else if segue.identifier == "AddCheckList"{
            
            let navigationVC = segue.destinationViewController as! UINavigationController
            let addVC = navigationVC.topViewController as! ListDetailTableViewController
            addVC.delegate = self
            addVC.checkListToEdit = nil
        }
    }
    
    // 视图将要显示的时候保存一下数据
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // 重载数据
        self.tableView.reloadData()
        
        // 保存数据
        listsDataModel!.savaListsData()
    }

}
