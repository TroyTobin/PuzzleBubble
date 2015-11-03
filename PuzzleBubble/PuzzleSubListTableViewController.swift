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
    
    /// Set the notification handler for reloading the sub-puzzle table
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadSubPuzzles:", name: "reloadSubPuzzles",object: nil)
  }
  
  
  /// Refresh the subPuzzle Groups
  func reloadSubPuzzles(notification: NSNotification) {
    /// Retrieve the list of puzzle groups available
    PBClient.sharedInstance.getPuzzleSubGroups() { results, errorString in
      
      if let inError = errorString {
        /// Error getting the puzzle groups
        print("Error \(inError)")
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
    return 0
  }
  
  /// delegate function to set a cell contents
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    /// get a reusable cell to populate
    let cell = tableView.dequeueReusableCellWithIdentifier("PuzzleSubGroupCell")! as! PuzzleSubListViewCell
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
    
    let puzzleQuestionController = self.storyboard!.instantiateViewControllerWithIdentifier("QuestionPuzzleView") as! PuzzleQuestionSelectViewController
    
    let puzzleGroup = self.subPuzzles![indexPath.row] as! NSDictionary
    let level = puzzleGroup.valueForKey("level") as! Int
    
    puzzleQuestionController.puzzleLevel = level
    puzzleQuestionController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    self.presentViewController(puzzleQuestionController, animated: true, completion: nil)
  }
}