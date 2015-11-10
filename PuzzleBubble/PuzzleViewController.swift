//
//  PuzzleViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 5/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit
import CoreData

class PuzzleViewController: UIViewController {

  @IBOutlet weak var PuzzleQuestion: UITextView!
  @IBOutlet weak var PuzzleVariables: UITextView!
  @IBOutlet weak var timerLabel: UITextView!
  
  var questionId:String? = nil
  var timer: NSTimer? = nil
  var startDate: Double? = nil
  
  /// Managed object context
  var sharedContext: NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  
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
    /// Set the notification handler for reloading the answers
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadAnswers:", name: "reloadAnswers", object: nil)
    /// Set the notification handler for performing actions once the problem has been solved
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "problemSolved:", name: "problemSolved", object: nil)
    
    /// notify listeners they can use the data
    NSNotificationCenter.defaultCenter().postNotificationName("reloadQuestion", object: nil)
  }

  /// Refresh the question
  func reloadQuestion(notification: NSNotification) {
    self.startDate = 0.0
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
            if question![elementIdx] as! String == "?" {
              questionString += "A \(PBClient.getOperator()!) "
              
            } else {
              questionString += "\(question![elementIdx]) \(PBClient.getOperator()!) "
            }
            elementIdx++
          }
          if question![elementIdx] as! String == "?" {
            questionString += "A = ?"
            
          } else {
            questionString += "\(question![elementIdx]) = ?"
          }
          
          
          let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.alignment = NSTextAlignment.Center
          
          let questionFontAttributes = [
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 28.0)!,
            NSForegroundColorAttributeName: UIColor(red:0.11, green:0.41, blue:0.17, alpha:1.0),//UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
            NSParagraphStyleAttributeName: paragraphStyle
          ]
          
          let questionLabel = NSAttributedString(string: questionString, attributes: questionFontAttributes)
          
          dispatch_async(dispatch_get_main_queue(), {
            self.PuzzleQuestion.attributedText = questionLabel
          })
        }
        
        // Retrieve the variable list
        if let _variables = resultsContainer?[0].valueForKey("variables") as? NSArray {
          variables = _variables
          print ("variables = \(variables)")
          var variablesString = "VARIABLE LIST\n"
          var elementIdx = 0
          
          // Create the string representation of the variable list
          // and set the UI text view with the contents
          while elementIdx < (variables!.count) {
            variablesString += "A = \(variables![elementIdx])\n"
            elementIdx++
          }
          
          let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.alignment = NSTextAlignment.Center
          
          let variablesFontAttributes = [
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 17.0)!,
            NSForegroundColorAttributeName: UIColor(red:0.95, green:0.30, blue:0.15, alpha:1.0),
            NSParagraphStyleAttributeName: paragraphStyle
          ]
          
          let variablesLabel = NSAttributedString(string: variablesString, attributes: variablesFontAttributes)

          dispatch_async(dispatch_get_main_queue(), {
            self.PuzzleVariables.attributedText = variablesLabel
          })
        }
        
        // Retrieve the max time
        PBClient.max_time = 0
        print("getting the max_time")
        if let _max_time = resultsContainer?[0].valueForKey("max_time") as? Int {
          PBClient.max_time = _max_time
        }
        print ("max_time = \(PBClient.max_time)")
        
        // Retrieve the max score
        PBClient.max_score = 0
        if let _max_score = resultsContainer?[0].valueForKey("max_score") as? Int {
          PBClient.max_score = _max_score
        }
        
        // calculate all of the answers to the questions
        PBClient.answers = PBClient.sharedInstance.getPuzzleAnswers(question, variables: variables)
    
        // Notify the grid view to set the answers in the cells
        NSNotificationCenter.defaultCenter().postNotificationName("reloadAnswers", object: nil)
      }
    }
    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
  }
  
  /// Refresh the answers
  func reloadAnswers(notification: NSNotification) {
    self.startDate = Double(PBClient.max_time!);
  }
  
  
  ///
  func problemSolved(notification: NSNotification) {
    self.stopTimer()
    let max_time  = Double(PBClient.max_time!)
    let max_score = Double(PBClient.max_score!)
    
    let solved_time = self.startDate!
    
    let score = max_score*solved_time/max_time;
    print("Score = \(score)")
    
    if (PBClient.correct) {
      // Add the score to the user
      let user = PBClient.currentUser
      
      user?.score = Int((user?.score)!) + Int(score)
      
      print("question id solved = \(self.questionId!)")
      let dictionary: [String : AnyObject] = [
        Question.Keys.Id : self.questionId!
      ]
      
      /// Now we create a new Person, using the shared Context
      let question = Question(dictionary: dictionary, context: sharedContext)
      let completed = user?.completed as! NSMutableSet
      completed.addObject(question)
      
      CoreDataStackManager.sharedInstance().saveContext()
      NSNotificationCenter.defaultCenter().postNotificationName("reloadTables", object: nil)
      
      self.dismissViewControllerAnimated(true, completion: nil)
      
    } else {
      // pop up alert view to indicate the user may try again
    }
  }

  func stopTimer() {
    self.timer!.invalidate();
  }
  
  func updateTimer() {
    // Create date from the elapsed time
    self.startDate! -= 0.1
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.Center
    
    let timeFontAttributes = [
      NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 20.0)!,
      NSForegroundColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
      NSParagraphStyleAttributeName: paragraphStyle
    ]
    
    let timeLabel = NSAttributedString(string: NSString(format: "%.1f", self.startDate!) as String, attributes: timeFontAttributes)

    dispatch_async(dispatch_get_main_queue(), {
      self.timerLabel?.attributedText = timeLabel
    })
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

