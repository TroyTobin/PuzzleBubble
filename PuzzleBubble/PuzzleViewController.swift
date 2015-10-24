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
        
        print ("results puzzle view = \(resultsContainer)")
        if let question = resultsContainer?[0].valueForKey("question") as? NSArray {
          var questionString = ""
          var elementIdx = 0
          while elementIdx < (question.count - 1) {
            questionString += "\(question[elementIdx]) + "
            elementIdx++
          }
          questionString += "\(question[elementIdx])"
          print ("questionString = \(questionString)")
          dispatch_async(dispatch_get_main_queue(), {
            self.PuzzleQuestion.text = questionString
          })
        }
        if let variables = resultsContainer?[0].valueForKey("variables") as? NSArray {
          print ("variables = \(variables)")
          var variablesString = ""
          var elementIdx = 0
          while elementIdx < (variables.count) {
            variablesString += "? = \(variables[elementIdx])\n"
            elementIdx++
          }
          dispatch_async(dispatch_get_main_queue(), {
            self.PuzzleVariables.text = variablesString
          })
        }
      }
    }
  }
}

