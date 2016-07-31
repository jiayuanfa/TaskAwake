//
//  AddNewEventVC.swift
//  TaskAwoke
//
//  Created by JiaYuanFa on 16/7/20.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

import UIKit

protocol MainListControllerDelegate {
    
    func addItem(item:MainItem)
    func editItem(item:MainItem)
}

class AddNewEventVC: UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var doneButton: UIBarButtonItem!

    @IBOutlet weak var newTaskCategory: UITextField!
    
    @IBOutlet weak var awakeTimeLable: UILabel!
    @IBOutlet weak var awakeSwitch: UISwitch!
    var delegate:MainListControllerDelegate?
    
    var itemToEdit = MainItem?()
    var dueDate:NSDate?
    var datePickerVisible:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newTaskCategory.delegate = self;
        
        if itemToEdit != nil {
            self.title = "编辑任务"
            self.newTaskCategory.text = itemToEdit?.text
            self.doneButton.enabled = true
            self.awakeSwitch.on = itemToEdit!.shouldRemind
            self.dueDate = itemToEdit!.awakeTime
        }else{
            awakeSwitch.on = false
            dueDate = NSDate()
        }
        
        // 默认显示当前时间
        updateDueDateLabel()
    }
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDatePicker = NSIndexPath(forRow: 2,inSection: 1)
        self.tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDatePicker = NSIndexPath(forRow: 2,inSection: 1)
            self.tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        print("\(textField.text)")
        
        let newText = textField.text?.stringByReplacingCharactersInRange(range.toRange(textField.text!), withString: string)
        
        doneButton.enabled = newText!.characters.count > 0
        return true
    }
    

    @IBAction func cancleClick(sender: UIBarButtonItem) {
        
        self .dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func textDidEndOn(sender: UITextField) {
        
        doneClick(UIBarButtonItem.init())
    }
    
    @IBAction func doneClick(sender: UIBarButtonItem) {
        let item = MainItem(text: self.newTaskCategory.text!, checked:false,dueDate: self.dueDate!,shouldRemind:self.awakeSwitch.on)
        if itemToEdit == nil {
            // 说明是添加任务 直接响应代理 传出任务  并且判断是否需要调用本地通知
            item.scheduleNotification()
            delegate?.addItem(item)
        }else{
            itemToEdit?.text = self.newTaskCategory.text!
            itemToEdit?.shouldRemind = self.awakeSwitch.on
            itemToEdit?.awakeTime = self.dueDate!
            
            // 说明是编辑任务 赋值之后响应代理 并且判断是否需要调用本地通知
            itemToEdit?.scheduleNotification()
            delegate?.editItem(itemToEdit!)
        }
        self .dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        self.awakeTimeLable.text = formatter.stringFromDate(self.dueDate!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 && datePickerVisible {
            return 3
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    

    //MARK:重写cellForRow的方法 来初始化日期选择器
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("datePickerCellIdentifier") as UITableViewCell?
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "datePickerCellIdentifier")
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                let datePicker = UIDatePicker(frame:CGRectMake(0.0,0.0,320.0,216.0))
                datePicker.tag = 100
                datePicker.addTarget(self, action: #selector(AddNewEventVC.dateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell?.contentView.addSubview(datePicker)
            }
            return cell!
        }else{
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    //MARK:日期改变 刷新Label
    func dateChanged(datePicker:UIDatePicker) {
        self.dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    //MARK:编辑任务名称的时候关闭选择器
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
    }
    
    //MARK:重新设置Cell高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 216.0
        }else{
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    //MARK:由于我们手动实现了Cell 将在storyboard的静态Cell给破坏掉了 所以我们还要实现以下的方法 
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            // 强插Cell
            let newIndexPath = NSIndexPath(forRow: 0,inSection: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAtIndexPath: newIndexPath)
        }else{
            return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
        }
    }
    
    //MARK: 选中之后 让textField失去焦点 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 让点击效果消失
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // 让textField失去焦点
        self.newTaskCategory.resignFirstResponder()
        if indexPath.row == 1 && indexPath.section == 1 {
            if datePickerVisible {
                hideDatePicker()
            }else{
                showDatePicker()
            }
        }
    }

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

extension NSRange{
    func toRange(string:String) -> Range<String.Index>{
        let startIndex = string.startIndex.advancedBy(self.location)
        let endIndex = startIndex.advancedBy(self.length)
        return startIndex..<endIndex
    }
}


