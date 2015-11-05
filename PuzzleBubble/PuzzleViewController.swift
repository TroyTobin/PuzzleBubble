//
//  PuzzleViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 5/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {

  @IBOutlet weak var PuzzleQuestion: UITextView!
  @IBOutlet weak var PuzzleVariables: UITextView!
  @IBOutlet weak var timerLabel: UITextView!
  
  var questionId:String? = nil
  var timer: NSTimer? = nil
  var startDate: Double? = nil
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// Set the puzzle question in the PB Client so it can
    /// be used for further queries
    PBClient.questionId = questionId
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
    self.PuzzleQuestion.layer.cornerRadius = 10
    self.PuzzleQuestion.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.PuzzleQuestion.layer.borderWidth = 2.0;
    self.PuzzleVariables.layer.cornerRadius = 10
    self.PuzzleVariables.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.PuzzleVariables.layer.borderWidth = 2.0;
    self.timerLabel.layer.cornerRadius = 10
    self.timerLabel.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.timerLabel.layer.borderWidth = 2.0;
    
    print ("Set the question to \(PBClient.questionId)")
    /// Set the notification handler for reloading the question
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadQuestion:", name: "reloadQuestion",object: nil)
    
    /// notify listeners they can use the data
    NSNotificationCenter.defaultCenter().postNotificationName("reloadQuestion", object: nil)
  }
  
  
  /// Refresh the question
  func reloadQuestion(notification: NSNotification) {
    /// Retrieve the list of puzzle groups available
    PBClient.sharedInstance.getPuzzleEquation() { results, errorString in
      
      if let inError = errorString {
        /// Error getting the puzzle groups
        print("Error \(inError)")
      } else {
        /// Okay so far - but is there a "user" JSON object?
        let resultsContainer = results?.valueForKey("results") as? NSArray
        var question:NSArray? = nil
        var variables:NSArray? = nil
        var questionString:String = ""
        
        print ("results puzzle view = \(resultsContainer)")
        
        // Retrieve the puzzle question
        if let _question = resultsContainer?[0].valueForKey("question") as? NSArray {
          question = _question
          var elementIdx = 0
          
          // Create the string representation of the questions
          // and set the UI text label with the contents
          while elementIdx < (question!.count - 1) {
            questionString += "\(question![elementIdx]) \(PBClient.getOperator()!) "
            elementIdx++
          }
          questionString += "\(question![elementIdx])"
          print ("questionString = \(questionString)")
          dispatch_async(dispatch_get_main_queue(), {
            self.PuzzleQuestion.text = questionString
          })
        }
        
        // Retrieve the variable list
        if let _variables = resultsContainer?[0].valueForKey("variables") as? NSArray {
          variables = _variables
          print ("variables = \(variables)")
          var variablesString = ""
          var elementIdx = 0
          
          // Create the string representation of the variable list
          // and set the UI text view with the contents
          while elementIdx < (variables!.count) {
            variablesString += "? = \(variables![elementIdx])\n"
            elementIdx++
          }
          dispatch_async(dispatch_get_main_queue(), {
            self.PuzzleVariables.text = variablesString
          })
        }
        
        // calculate all of the answers to the questions
        PBClient.answers = PBClient.sharedInstance.getPuzzleAnswers(question, variables: variables)
    
        // Notify the grid view to set the answers in the cells
        NSNotificationCenter.defaultCenter().postNotificationName("reloadAnswers", object: nil)
      }
    }
    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
    self.startDate = 60.0;
  }

  func stopTimer() {
    self.timer!.invalidate();
  }
  
  func updateTimer() {
    // Create date from the elapsed time
    self.startDate! -= 0.1
    self.timerLabel?.text = NSString(format: "%.1f", self.startDate!) as String
  }
  
  @IBAction func resetQuestion(sender: AnyObject) {
    PBClient.correct = false
    PBClient.selectedAnswers = []
    
    // Notify the grid view to set the answers in the cells
    NSNotificationCenter.defaultCenter().postNotificationName("reloadQuestion", object: nil)
    
  }
  
  /// Dismiss this view controller
  @IBAction func dismissView(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
}

