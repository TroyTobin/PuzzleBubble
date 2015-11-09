//
//  SettingsViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 8/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit

/// Table view controller to display the settings
class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var settingList = ["New Player", "Change Player", "About"]
  
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
  
  /// delegate function to return the count of elements
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.settingList.count
  }
  
  /// delegate function to set a cell contents
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    /// get a reusable cell to populate
    let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell")! as! SettingsViewCell
    let settingsFontAttributes = [
      NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 16.0)!,
      NSForegroundColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
    ]
  
    let settingsLabel = NSAttributedString(string: self.settingList[indexPath.row], attributes: settingsFontAttributes)
  
    cell.settingsLabel.attributedText = settingsLabel
    
    return cell
  }
  
  /// delegate function when cell selected.
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if (self.settingList[indexPath.row] == "New Player") {
      
      let newUserController = self.storyboard!.instantiateViewControllerWithIdentifier("NewUserView") as! NewUserViewController
      self.presentViewController(newUserController, animated: true, completion: nil)
    } else if (self.settingList[indexPath.row] == "Change Player") {
      let changeUserController = self.storyboard!.instantiateViewControllerWithIdentifier("ChangeUserView") as! ChangeUserViewController
      self.presentViewController(changeUserController, animated: true, completion: nil)
    } else if (self.settingList[indexPath.row] == "About") {
      let aboutController = self.storyboard!.instantiateViewControllerWithIdentifier("AboutView") as! AboutViewController
      self.presentViewController(aboutController, animated: true, completion: nil)
    }
  }
}



