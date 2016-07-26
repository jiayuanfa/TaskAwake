//
//  ListDetailTableViewController.swift
//  TaskAwoke
//
//  Created by JiaYuanFa on 16/7/23.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

import UIKit

protocol ListDetailTableViewDelegate {
    
    func cancle()
    func addFinish(checkList:CheckList)
    func editFinish(checkList:CheckList)
}

class ListDetailTableViewController: UITableViewController,UITextFieldDelegate {

    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet weak var addTaskTextField: UITextField!
    
    var checkListToEdit:CheckList?
    var delegate:ListDetailTableViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if checkListToEdit != nil {
            self.title = "编辑任务类型"
            self.addTaskTextField.text = self.checkListToEdit?.name
        }
        
        addTaskTextField.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addTaskTextField.becomeFirstResponder()
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
        return 1
    }
    @IBAction func didEndOnExit(sender: UITextField) {
        doneOnClick(UIBarButtonItem())
    }
    @IBAction func cancleOnClick(sender: UIBarButtonItem) {
        delegate?.cancle()
    }
    @IBAction func doneOnClick(sender: UIBarButtonItem) {
        if checkListToEdit == nil {
            // 增加数据
            let checkList = CheckList(name:addTaskTextField.text!)
            delegate?.addFinish(checkList)
        }else{
            // 修改数据
            checkListToEdit?.name = self.addTaskTextField.text!
            delegate?.editFinish(checkListToEdit!)
        }
    }
    
    //响应文本变化
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // 获取到文本框的最新数据
        let newText = textField.text?.stringByReplacingCharactersInRange(range.toRange(textField.text!), withString: string)
        
        // 通过计算文本框内的字符数来决定done按钮是否激活
        doneButtonItem.enabled = newText!.characters.count > 0
        
        return true
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
