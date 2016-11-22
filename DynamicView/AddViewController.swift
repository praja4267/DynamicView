//
//  AddViewController.swift
//  DynamicView
//
//  Created by Active Mac05 on 21/11/16.
//  Copyright © 2016 techactive. All rights reserved.
//

import UIKit

protocol addReportDelegate {
    func passReportDetails(reportArray : [String])
}
class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet var addReportTableVIew: UITableView!
    @IBOutlet var dropDownHolderView: UIView!
    @IBOutlet var dropDownTableView: UITableView!
    
    var addRepostVCdelegate : addReportDelegate!
    var responseArray = [Dictionary <String, AnyObject>]()
    var dropDownArray = [String]()
    var selectedString = ""
    var PassingArray = [String]()
    var numberOfFields = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReportTableVIew.dataSource = self
        addReportTableVIew.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.delegate = self
        dropDownHolderView.hidden = true
        dropDownTableView.hidden = true
        responseArray =  self.parseJsonData(true)
        dropDownTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addReportTableVIew.estimatedRowHeight = 80
        addReportTableVIew.rowHeight = UITableViewAutomaticDimension
        self.addReportTableVIew.setNeedsLayout()
        self.addReportTableVIew.layoutIfNeeded()
        addReportTableVIew.tableFooterView = UIView(frame: CGRectZero)
        dropDownTableView.tableFooterView = UIView(frame: CGRectZero)
        addReportTableVIew.backgroundColor = UIColor.brownColor()
        self.navigationController?.navigationBarHidden = true
        /*
         
         [
         {'field-name':'name', 'type':'text',"unique_id":1},
         {'field-name':'age', 'type':'number',"unique_id":2},
         {'field-name':'gender', 'type':dropdown', 'options':['male', 'female', 'other'],"unique_id":3},
         {'field-name':'address', 'type':'multiline',"unique_id":4}
         ]
         */
        // Do any additional setup after loading the view.
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == addReportTableVIew {
            return responseArray.count
        }else{
            return dropDownArray.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if tableView == addReportTableVIew {
            if (responseArray[indexPath.row]["type"] as! String == "text") ||  (responseArray[indexPath.row]["type"] as! String == "number") {
                
                let cell1 : TextFieldTableViewCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
                cell1.labelForTextField.text = responseArray[indexPath.row]["field-name"] as? String
                cell1.labelForTextField.backgroundColor = UIColor.orangeColor()
                cell1.textfiled.tag = (responseArray[indexPath.row]["unique_id"] as? Int)! - 1
                cell1.textfiled.delegate = self
                if (responseArray[indexPath.row]["type"] as! String == "number") {
                    cell1.textfiled.keyboardType = UIKeyboardType.NumberPad
                }else{
                   cell1.textfiled.keyboardType = UIKeyboardType.Alphabet
                }
                return cell1
            } else if(responseArray[indexPath.row]["type"] as! String == "multiline") {
                
                let cell2 : TextViewTableViewCell = tableView.dequeueReusableCellWithIdentifier("TextViewTableViewCell", forIndexPath: indexPath) as! TextViewTableViewCell
                cell2.labelForTextView.text = responseArray[indexPath.row]["field-name"] as? String
                cell2.multiLineTextView.delegate=self
                cell2.multiLineTextView.tag = (responseArray[indexPath.row]["unique_id"] as? Int)! - 1
                cell2.labelForTextView.backgroundColor = UIColor.orangeColor()
                self.addDoneButtonOnKeyboard(cell2.multiLineTextView)
                return cell2
            } else if(responseArray[indexPath.row]["type"] as! String == "dropdown"){
                let cell3 : LabelTableViewCell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell", forIndexPath: indexPath) as! LabelTableViewCell
                cell3.labelForTVCell.text = responseArray[indexPath.row]["field-name"] as? String
                cell3.labelForTVCell.backgroundColor = UIColor.orangeColor()
                cell3.valueLabel.text = selectedString
                cell3.valueLabel.tag = (responseArray[indexPath.row]["unique_id"] as? Int)! - 1
                PassingArray[(responseArray[indexPath.row]["unique_id"] as? Int)! - 1] = selectedString
                return cell3
            }
        }else{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = dropDownArray[indexPath.row]
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == addReportTableVIew {
            if(responseArray[indexPath.row]["type"] as! String == "dropdown"){
                dropDownArray=responseArray[indexPath.row]["options"] as! [String]
                dropDownTableView.frame = CGRect(origin: tableView.rectForRowAtIndexPath(indexPath).origin, size: CGSize(width: self.view.frame.size.width - 100, height: CGFloat(44 * dropDownArray.count)))
                
                dropDownHolderView.hidden = false
                dropDownTableView.hidden = false
                dropDownTableView.reloadData()
            }
        }else{
           selectedString = dropDownArray[indexPath.row]
            dropDownHolderView.hidden = true
            addReportTableVIew.reloadData()
            
        }
        

    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        print("Total elements in pass array \(PassingArray.count) , elements are \(PassingArray)and the tag = \(textView.tag)");
        PassingArray[textView.tag] = textView.text!
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        PassingArray[textField.tag] = textField.text!
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        PassingArray[textField.tag] = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    func addDoneButtonOnKeyboard(sender: UITextView) {
        
        let keypadToolbar: UIToolbar = UIToolbar()
        
        // add a done button to the numberpad
        keypadToolbar.items=[
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: sender, action: #selector(sender.resignFirstResponder)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        ]
        keypadToolbar.sizeToFit()
        // add a toolbar with a done button above the number pad
        sender.inputAccessoryView = keypadToolbar
    }

    
    func parseJsonData(showFour : Bool) -> [Dictionary<String, AnyObject>]{
        
        if showFour {
            let arr : [Dictionary<String, AnyObject>] = [ [ "field-name" : "name", "type" : "text","unique_id" : 1, "required" : 1],
                                                          [ "field-name" : "age", "type" : "number","unique_id" : 2, "min" : 20, "max" : 60],
                                                          ["field-name":"gender", "type":"dropdown", "options":["male", "female", "other"],"unique_id":3],
                                                          ["field-name":"address", "type":"multiline","unique_id":4,  "required" : 0]]
            for _ in arr {
                PassingArray.append("")
            }
            numberOfFields = arr.count
            return arr
        } else{
            let arr : [Dictionary<String, AnyObject>] = [ [ "field-name" : "name", "type" : "text","unique_id" : 1, "required" : 1],
                                                          [ "field-name" : "age", "type" : "number","unique_id" : 2, "min" : 20, "max" : 60],
                                                          ["field-name":"address", "type":"multiline","unique_id":3,  "required" : 0]]
            for _ in arr {
                PassingArray.append("")
            }
            numberOfFields = arr.count
            return arr
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func doneButtonAction(sender: AnyObject) {
        self.view.endEditing(true)
        for (index, element) in responseArray.enumerate() {
            if (element["required"] != nil && (element["required"]?.boolValue)! && PassingArray[index] == "") {
                self.displayAlertWithTitleAndMessage("\(element["field-name"] as! String) field is mandatory", message: "Please enter your \(element["field-name"] as! String)")
                return
            }
            if element["min"] != nil && (PassingArray[index] == "" || Int(PassingArray[index]) < (element["min"] as? Int)!){
                if PassingArray[index] == "" {
                    self.displayAlertWithTitleAndMessage("Please enter Your age", message: "")
                }else{
                  self.displayAlertWithTitleAndMessage("your age is less than minimum age \(element["min"]!)", message: "")
                }
                
                print("show alert controller here minimum is \(element["min"]!)");
                return
            }
            if element["max"] != nil && (PassingArray[index] == "" || Int(PassingArray[index]) > (element["max"] as? Int)!){
                if PassingArray[index] == "" {
                    self.displayAlertWithTitleAndMessage("Please enter Your age", message: "")
                }else{
                    self.displayAlertWithTitleAndMessage("your age is more than than maximum age \(element["max"]!)", message: "")
                }
               
                 print("show alert controller here maximum is \(element["max"]!)")
                return
            }
            
        }
        if addRepostVCdelegate != nil {
            addRepostVCdelegate.passReportDetails(PassingArray)
        }
        self.navigationController?.popViewControllerAnimated(true)

    }
    

    func displayAlertWithTitleAndMessage(title : String, message : String) {
        let alertController = UIAlertController(title:title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
