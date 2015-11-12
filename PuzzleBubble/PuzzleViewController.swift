//
//  PuzzleViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 5/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit
import CoreData


/// This class is the puzzle view controller that shows the puzzle
/// as well as the embedded answer grid
class PuzzleViewController: UIViewController {

  @IBOutlet weak var PuzzleQuestion: UITextView!
  @IBOutlet weak var PuzzleVariables: UITextView!
  @IBOutlet weak var timerLabel: UITextView!
  
  var questionId:String? = nil
  var timer: NSTimer? = nil
  var startDate: Double? = nil
  var started: Bool = false
  
  /// Managed object context
  var sharedContext: NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// Set the puzzle question in the PB Client so it can
    /// be used for further queries
    PBClient.questionId = questionId
    
    /// Update the look of the various view elements so they are consistently styled.
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
            NSForegroundColorAttributeName: UIColor(red:0.11, green:0.41, blue:0.17, alpha:1.0),
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
        if let _max_time = resultsContainer?[0].valueForKey("max_time") as? Int {
          PBClient.max_time = _max_time
        }
        
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
    self.started = true
  }
  
  
  /// performs necessary actions when a puzzle is attempted
  /// It will check the answers and either dismiss the view if correct
  /// or pop up an alert view indicating the answer order was incorrect
  func problemSolved(notification: NSNotification) {
    self.stopTimer()
    let max_time  = Double(PBClient.max_time!)
    let max_score = Double(PBClient.max_score!)
    
    let solved_time = self.startDate!
    
    /// Determine the score that the user has achieved as
    ///  a percentage of the max_score based on how long it too to complete
    let score = max_score*solved_time/max_time;
    
    if (PBClient.correct) {
      // Add the score to the user since the qanswer was correct
      let user = PBClient.currentUser
      
      user?.score = Int((user?.score)!) + Int(score)
      
      let dictionary: [String : AnyObject] = [
        Question.Keys.Id : self.questionId!
      ]
      
      /// Instantiate the question object with this solved question
      let question = Question(dictionary: dictionary, context: sharedContext)
      let completed = user?.completed as! NSMutableSet
      
      /// Check if the question has already been solved
      var alreadySolved = false
      for q in completed {
        let _q = q as! Question
        if _q.id == question.id {
          alreadySolved = true
        }
      }
      
      if !alreadySolved {
        // Not solved so add to the list of completed questions
        completed.addObject(question)
      }
      
      // Save all updates to core data.
      CoreDataStackManager.sharedInstance().saveContext()
      
      // Refresh the views
      NSNotificationCenter.defaultCenter().postNotificationName("reloadTables", object: nil)
      
      // Solved so exit the current view
      self.dismissViewControllerAnimated(true, completion: nil)
      
    } else {
      // pop up alert view to indicate the user may try again
      let alertController = UIAlertController(title: "Incorrect", message: "Try Again?", preferredStyle: .Alert)
      
      let okayAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
        // Notify the grid view to set the answers in the cells
        NSNotificationCenter.defaultCenter().postNotificationName("reloadQuestion", object: nil)
        
      }
      alertController.addAction(okayAction)
      
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }

  /// Stop the timer counting down
  func stopTimer() {
    self.started = false
    self.timer!.invalidate();
  }
  
  /// Update the timer for the current puzzle
  func updateTimer() {
    // Create date from the elapsed time
    if self.started == false {
      return
    }
    
    self.startDate! -= 0.1
    if self.startDate! <= 0.0 {
      /// time has expired so stop the puzzle and alert the user
      self.stopTimer()
      
      // pop up alert view to indicate the user may try again
      let alertController = UIAlertController(title: "Time Expired", message: "Try Again?", preferredStyle: .Alert)
      
      let okayAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
        // Notify the grid view to set the answers in the cells
        NSNotificationCenter.defaultCenter().postNotificationName("reloadQuestion", object: nil)
        
      }
      alertController.addAction(okayAction)
      
      self.presentViewController(alertController, animated: true, completion: nil)
    } else {
    
    
      /// Update the timer in the view
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
  }
  
  
  /// Reset the question.  Involves reloading the question view
  @IBAction func resetQuestion(sender: AnyObject) {
    PBClient.correct = false
    PBClient.selectedAnswers = []
    self.stopTimer()
    
    // Notify the grid view to set the answers in the cells
    NSNotificationCenter.defaultCenter().postNotificationName("reloadQuestion", object: nil)
    
  }
  
  /// Dismiss this view controller
  @IBAction func dismissView(sender: AnyObject) {
    self.stopTimer()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
}

