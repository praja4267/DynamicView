//
//  ViewController.swift
//  DynamicView
//
//  Created by Active Mac05 on 21/11/16.
//  Copyright © 2016 techactive. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, addReportDelegate {

    @IBOutlet var noOfReortsLabel: UILabel!
    @IBOutlet var reportsListTableView: UITableView!
    var responseArray = [[String]]()
    let identifierString = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        reportsListTableView.dataSource = self
        reportsListTableView.delegate = self
        reportsListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifierString)
        reportsListTableView.tableFooterView=UIView(frame: CGRectZero)
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBarHidden = false
        noOfReortsLabel.text = "Total Reports :\(responseArray.count)"
        reportsListTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifierString)
        
        cell.textLabel?.text = "\(responseArray[indexPath.row][0])"
        if responseArray[indexPath.row].count > 1 {
            cell.detailTextLabel?.text = "\(responseArray[indexPath.row][1])"
        } else {
            print(responseArray[indexPath.row].count)
        }

        
        return cell
}
    
    
    func passReportDetails(reportArray: [String]) {
        
        responseArray.append(reportArray)
        print(responseArray)
    }
    
    
    
    @IBAction func addNewReportAction(sender: AnyObject) {
        let cntl = self.storyboard?.instantiateViewControllerWithIdentifier("AddViewController") as! AddViewController
        cntl.addRepostVCdelegate = self
        self.navigationController?.pushViewController(cntl, animated: true)
    }
    

}

