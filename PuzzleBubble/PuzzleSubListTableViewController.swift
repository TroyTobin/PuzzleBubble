//
//  PuzzleSubListTableViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 18/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit

/// Table view controller to display the list of Puzzle Groups
class PuzzleSubListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var subPuzzles: NSArray? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// we are a delegate to the table view
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.layer.cornerRadius = 10
    self.tableView.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.tableView.layer.borderWidth = 2.0;
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
    
    /// Set the notification handler for reloading the sub-puzzle table
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadSubPuzzles:", name: "reloadSubPuzzles",object: nil)
    /// Set the notification handler for reloading the table
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTables:", name: "reloadTables", object: nil)
  }
  
  
  /// Refresh the table
  func reloadTables(notification: NSNotification) {
    dispatch_async(dispatch_get_main_queue(), {
      self.tableView.reloadData()
    })
  }
  
  
  /// Refresh the subPuzzle Groups
  func reloadSubPuzzles(notification: NSNotification) {
    /// Retrieve the list of puzzle groups available
    PBClient.sharedInstance.getPuzzleSubGroups() { results, errorString in
      
      if let inError = errorString {
        /// Error getting the puzzle levels - inform the user
        let alertController = UIAlertController(title: "Failed to get Puzzle Levels", message: "\(inError)", preferredStyle: .Alert)
        
        let okayAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
          // Do nothing
        }
        alertController.addAction(okayAction)
        
        dispatch_async(dispatch_get_main_queue(), {
          self.presentViewController(alertController, animated: true, completion: nil)
        })
      } else {
        /// Okay so far - but is there a "user" JSON object?
        let resultsContainer = results?.valueForKey("results") as? NSArray
        
        /// There should only be 1 results which is an array of puzzles
        if resultsContainer?.count == 1 {
          if let _ = PBClient.puzzleGroup {
            let puzzles = resultsContainer?[0].valueForKey(PBClient.puzzleGroup!) as? NSArray
            self.subPuzzles = puzzles!
          
            dispatch_async(dispatch_get_main_queue(), {
              self.tableView.reloadData()
            })
          }
        }

      }
    }
  }
  
  /// delegate function to return the count of elements
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let _ = self.subPuzzles {
      return self.subPuzzles!.count
    }
    return 1
  }
  
  /// delegate function to set a cell contents
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    /// get a reusable cell to populate
    let cell = tableView.dequeueReusableCellWithIdentifier("PuzzleSubGroupCell")! as! PuzzleSubListViewCell
    
    if self.subPuzzles == nil || self.subPuzzles?.count == 0 {
      
      cell.activity.hidden = false
      return cell
    }
    
    cell.activity.hidden = true
    
    // get the student at the index
    let puzzleGroup = self.subPuzzles![indexPath.row] as! NSDictionary
    let level = puzzleGroup.valueForKey("level") as! Int
    
    /// set the cell contents
    cell.level = level
    
    cell.textLabel?.text = "\(PBClient.puzzleGroup!) - \(level)"
    return cell
  }
  
  /// delegate function when cell selected.  Want to load student media url in web view
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if self.subPuzzles == nil || self.subPuzzles?.count == 0 {
      return
    }
    
    let puzzleQuestionController = self.storyboard!.instantiateViewControllerWithIdentifier("QuestionPuzzleView") as! PuzzleQuestionSelectViewController
    
    let puzzleGroup = self.subPuzzles![indexPath.row] as! NSDictionary
    let level = puzzleGroup.valueForKey("level") as! Int
    
    puzzleQuestionController.puzzleLevel = level
    puzzleQuestionController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    self.presentViewController(puzzleQuestionController, animated: true, completion: nil)
  }
}