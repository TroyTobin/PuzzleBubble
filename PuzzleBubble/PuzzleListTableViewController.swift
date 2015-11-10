//
//  PuzzleListTableView.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 18/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit

/// Table view controller to display the list of Puzzle Groups
class PuzzleListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var puzzles: NSArray? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// Set the notification handler for reloading the table
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTables:", name: "reloadTables", object: nil)
    
    /// we are a delegate to the table view
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.layer.cornerRadius = 10
    self.tableView.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.tableView.layer.borderWidth = 2.0;
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
    dispatch_async(dispatch_get_main_queue(), {
      self.tableView.reloadData()
    })
    
    /// Retrieve the list of puzzle groups available
    PBClient.sharedInstance.getPuzzleGroups() { results, errorString in
      
      if let inError = errorString {
        /// Error getting the puzzle groups
        print("Error \(inError)")
      } else {
        /// Okay so far - but is there a "user" JSON object?
        let resultsContainer = results?.valueForKey("results") as? NSArray
        
        /// There should only be 1 results which is an array of puzzles
        if resultsContainer?.count == 1 {
          let groups = resultsContainer?[0].valueForKey("Groups") as? NSArray
          self.puzzles = groups!
        
          dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
          })
        }
      }
    }
  }
  
  
  /// Refresh the table
  func reloadTables(notification: NSNotification) {
    dispatch_async(dispatch_get_main_queue(), {
      self.tableView.reloadData()
    })
  }
  
  
  /// delegate function to return the count of elements
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let _ = self.puzzles {
      return self.puzzles!.count
    }
    return 1
  }
  
  /// delegate function to set a cell contents
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    /// get a reusable cell to populate
    let cell = tableView.dequeueReusableCellWithIdentifier("PuzzleGroupCell")! as! PuzzleListViewCell
    
    if self.puzzles == nil || self.puzzles?.count == 0 {
      return cell
    }
    
    cell.activity.hidden = true
    
    /// get the student at the index
    let puzzleGroup = self.puzzles![indexPath.row] as! NSDictionary
    let id = puzzleGroup.valueForKey("id") as! Int
    let title = puzzleGroup.valueForKey("title") as! String
    let description = puzzleGroup.valueForKey("description") as! String
   
    /// set the cell contents
    cell.id = id
    cell.puzzle = title
    cell.prose = description
    
    cell.textLabel?.text = title
    cell.detailTextLabel?.text = description
    
    return cell
  }
  
  /// delegate function when cell selected.  Want to load student media url in web view
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if self.puzzles == nil || self.puzzles?.count == 0 {
      return
    }
    
    let puzzleController = self.storyboard!.instantiateViewControllerWithIdentifier("SubPuzzleView") as! PuzzleSubSelectViewController
    
    let puzzleGroup = self.puzzles![indexPath.row] as! NSDictionary
    let title = puzzleGroup.valueForKey("title") as! String
    
    puzzleController.puzzleGroup = title
    puzzleController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    
    self.presentViewController(puzzleController, animated: true, completion: nil)
  }
}