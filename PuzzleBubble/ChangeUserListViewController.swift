//
//  ChangeUserListViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 9/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//


import UIKit

/// Table view controller to display a list of selectable users
class ChangeUserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// we are a delegate to the table view
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.layer.cornerRadius = 10
    self.tableView.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.tableView.layer.borderWidth = 2.0;
    
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
  }
  
  /// delegate function to return the count of users
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let users = PBClient.sharedInstance.retrieveUsers()
    return users.count
  }
  
  /// delegate function to set a cell contents
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    /// get a reusable cell to populate
    let cell = tableView.dequeueReusableCellWithIdentifier("ChangeUserCell")! as! ChangeUserListCell
    let settingsFontAttributes = [
      NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 16.0)!,
      NSForegroundColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
    ]
    
    let users = PBClient.sharedInstance.retrieveUsers()
    let userLabel = NSAttributedString(string: users[indexPath.row].name, attributes: settingsFontAttributes)
    cell.userName.attributedText = userLabel
    
    return cell
  }
  
  /// delegate function when cell selected.
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    /// update the current user with the selected one
    let users = PBClient.sharedInstance.retrieveUsers()
    let matchName = (users[indexPath.row] as! User).name
    for user in users {
      let _user = user as! User
      if _user.name == matchName {
        _user.isCurrent = true
        PBClient.currentUser = _user
      } else {
        _user.isCurrent = false
      }
    }
    CoreDataStackManager.sharedInstance().saveContext()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

