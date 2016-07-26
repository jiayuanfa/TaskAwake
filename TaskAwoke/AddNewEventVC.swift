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
    
    var delegate:MainListControllerDelegate?
    
    var itemToEdit = MainItem?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newTaskCategory.delegate = self;
        
        if itemToEdit != nil {
            self.title = "编辑任务"
            self.newTaskCategory.text = itemToEdit?.text
            self.doneButton.enabled = true
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
        let item = MainItem(text: self.newTaskCategory.text!, checked:false)
        if itemToEdit == nil {
            
            delegate?.addItem(item)
        }else{
            
            itemToEdit?.text = self.newTaskCategory.text!
            delegate?.editItem(itemToEdit!)
        }
        self .dismissViewControllerAnimated(true, completion: nil)
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

extension NSRange{
    func toRange(string:String) -> Range<String.Index>{
        let startIndex = string.startIndex.advancedBy(self.location)
        let endIndex = startIndex.advancedBy(self.length)
        return startIndex..<endIndex
    }
}


