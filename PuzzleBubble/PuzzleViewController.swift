//
//  PuzzleViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 5/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {

  @IBOutlet weak var PuzzleQuestion: UILabel!
  @IBOutlet weak var PuzzleVariables: UITextView!
  
  var questionId:String? = nil
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// Set the puzzle question in the PB Client so it can
    /// be used for further queries
    PBClient.questionId = questionId
    
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
  }
  
  /// Dismiss this view controller
  @IBAction func dismissView(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
}

