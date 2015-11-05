//
//  PuzzleQuestionListTableViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 18/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit

/// Table view controller to display the list of Puzzle Groups
class PuzzleQuestionListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  
  @IBOutlet weak var tableView: UITableView!
  var puzzleQuestions: NSArray? = nil
  
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
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadLevelQuestions:", name: "reloadLevelQuestions",object: nil)
  }
  
  
  /// Refresh the subPuzzle Groups
  func reloadLevelQuestions(notification: NSNotification) {
    /// Retrieve the list of puzzle groups available
    PBClient.sharedInstance.getPuzzleQuestions() { results, errorString in
      
      if let inError = errorString {
        /// Error getting the puzzle groups
        print("Error \(inError)")
      } else {
        /// Okay so far - but is there a "user" JSON object?
        let resultsContainer = results?.valueForKey("results") as? NSArray
        print("Results container = \(resultsContainer)")
        /// There should only be 1 results which is an array of puzzles
        if resultsContainer?.count == 1 {
          print ("Count == 1")
          if let puzzleGroup = PBClient.puzzleGroup {
            print ("puzzleGroup = \(puzzleGroup)")
            if let puzzles = resultsContainer?[0].valueForKey(PBClient.puzzleGroup!) as? NSArray {
              print ("puzzles = \(puzzles)")
              if let level = puzzles[PBClient.puzzleLevel! - 1] as? NSDictionary {
                print ("level = \(level)")
                if let questions = level.valueForKey("questions") as? NSArray {
                  print ("questions = \(questions)")
                  self.puzzleQuestions = questions
                }
              }
            }
          }
        }
            
        dispatch_async(dispatch_get_main_queue(), {
          self.tableView.reloadData()
        })
      }
    }
  }

  
  /// delegate function to return the count of elements
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let _ = self.puzzleQuestions {
      return self.puzzleQuestions!.count
    }
    return 0
  }
  
  /// delegate function to set a cell contents
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    /// get a reusable cell to populate
    let cell = tableView.dequeueReusableCellWithIdentifier("PuzzleQuestionCell")! as! PuzzleQustionListViewCell
    
    /// set the cell contents
    cell.textLabel?.text = "\(PBClient.puzzleGroup!) - \(PBClient.puzzleLevel!): \(indexPath.row + 1)"
    
    return cell
  }
  
  /// delegate function when cell selected.  Want to load student media url in web view
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let puzzleController = self.storyboard!.instantiateViewControllerWithIdentifier("PuzzleView") as! PuzzleViewController
    print ("Quesitons = \(self.puzzleQuestions)")
    puzzleController.questionId = self.puzzleQuestions![indexPath.row] as! String
    
    puzzleController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    self.presentViewController(puzzleController, animated: true, completion: nil)
  }
}
