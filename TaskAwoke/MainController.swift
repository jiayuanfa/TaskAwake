//
//  MainController.swift
//  TaskAwoke
//
//  Created by JiaYuanFa on 16/7/18.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

import UIKit

class MainController: UITableViewController,MainListControllerDelegate {
    
    var checkList:CheckList?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.checkList?.name
        
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
        return checkList!.mainItems.count
    }

    //MARK:设置Cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath)
        let label = cell.viewWithTag(1000) as? UILabel
        let labelCheck = cell.viewWithTag(1001) as? UILabel
        let item = checkList!.mainItems[indexPath.row]
        label?.text = item.text
        configureCheckmarkCell(labelCheck!, item: item)

        return cell
    }
    
    //MARK: 设置Cell是否选中
    func configureCheckmarkCell(label:UILabel,item:MainItem){
        if item.checked {
            label.text = "√"
        }else{
            label.text = ""
        }
    }
    
    @IBAction func addEvent(sender: AnyObject) {
        
    }
    
    //MARK:选中Cell 刷新Cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = checkList!.mainItems[indexPath.row];
        item.toggleChecked()
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let labelCheck = cell?.viewWithTag(1001) as? UILabel
        configureCheckmarkCell(labelCheck!, item: item)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //:MARK:跳转事件
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueStr:String! = "\(segue.identifier!)"
        if segueStr == "addItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AddNewEventVC
            controller.delegate = self
        }else if segueStr == "EditItem"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AddNewEventVC
            controller.delegate = self
            let indexPath = self.tableView.indexPathForCell(sender! as! UITableViewCell)
            controller.itemToEdit = checkList!.mainItems[indexPath!.row]
        }
    }
    
    //MARK:添加新数据
    func addItem(item: MainItem) {
        let index = checkList!.mainItems.count
            checkList!.mainItems.append(item)
        let indexPath = NSIndexPath(forRow:index, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    //MARK:编辑后的新数据
    func editItem(item:MainItem){
        self.tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete data
            checkList!.mainItems.removeAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
