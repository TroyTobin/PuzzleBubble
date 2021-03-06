//
//  PBClient.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 11/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import Foundation
import CoreData

/// This class represents the Puzzle Bubble API to the View controllers
class PBClient: NSObject, NSFetchedResultsControllerDelegate {
  
  var pbNet:PBNetLayer

  // Global variables to store the various state
  static var num_puzzles: Int = 0
  static var score_levels: NSArray? = nil
  static var score_text: NSArray? = nil
  static var puzzleGroup: String? = nil
  static var puzzleLevel: Int? = nil
  static var questionId: String? = nil
  static var question: NSArray? = nil
  static var max_time:Int = 0
  static var max_score:Int? = nil
  static var variables: NSArray? = nil
  static var answers: NSArray? = nil
  static var answersOrder: NSMutableArray? = nil
  static var selectedAnswers: NSMutableArray? = nil
  static var selectedAnswersOrder: NSMutableArray? = nil
  static var correct: Bool = false
  static var currentUser: User? = nil
  
  static let sharedInstance = PBClient()
  
  /// Managed object context
  var sharedContext: NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  /// Fetch controller to retrieve managed obejcts
  lazy var fetchedResultsController: NSFetchedResultsController = {
    
    let fetchRequest = NSFetchRequest(entityName: "User")
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
      managedObjectContext: self.sharedContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    return fetchedResultsController
    
  }()
  
  /// initialise and create a Puzzle Bubble Network Layer
  override init() {
    pbNet = PBNetLayer()
    super.init()
    /// This class is the FetchedResultsController delegate
    fetchedResultsController.delegate = self
  }
  
  /// Get the operator from a text description
  class func getOperator() -> String? {
    if PBClient.puzzleGroup == nil {
      return nil
    } else if PBClient.puzzleGroup == "Addition" {
      return  "+"
    } else if PBClient.puzzleGroup == "Subtraction" {
      return "-"
    } else if PBClient.puzzleGroup == "Multiplication" {
      return "x"
    } else if PBClient.puzzleGroup == "Division" {
      return "/"
    } else {
      return nil
    }
  }
  
  
  /// Perform an operation for the 2 input values
  class func doOperator(valueA: Int, valueB: Int) -> Int? {
    if PBClient.puzzleGroup == nil {
      return nil
    } else if PBClient.puzzleGroup == "Addition" {
      return  valueA + valueB
    } else if PBClient.puzzleGroup == "Subtraction" {
      return valueA - valueB
    } else if PBClient.puzzleGroup == "Multiplication" {
      return valueA * valueB
    } else if PBClient.puzzleGroup == "Division" {
      return valueA / valueB
    } else {
      return nil
    }
  }
  
  /// Get the list of puzzle groups that are currently available
  func getPuzzleGroups(completionHandler: (results: AnyObject?, errorString: String?) -> Void) {
    
    /// Retrieve the puzzle groups via the PB Network Layer
    pbNet.doParseGetReq(PBClient.ParseMethods.PuzzleGroups) { result, error in
      if let inError = error {
        completionHandler(results: nil, errorString: inError.localizedDescription)
      } else {
        completionHandler(results: result, errorString: nil)
      }
    }
  }
  
  /// Get the list of sub puzzles that are currently available
  func getPuzzleSubGroups(completionHandler: (results: AnyObject?, errorString: String?) -> Void) {
    if let _ = PBClient.puzzleGroup {
      
      /// Retrieve the sub-puzzle group via the PB Network Layer
      pbNet.doParseGetReq(PBClient.puzzleGroup!) { result, error in
        if let inError = error {
          completionHandler(results: nil, errorString: inError.localizedDescription)
        } else {
          completionHandler(results: result, errorString: nil)
        }
      }
    } else {
      completionHandler(results: nil, errorString: "Invalid sub puzzle \(PBClient.puzzleGroup)")
    }
  }
  
  /// Get the puzzle questions for the puzzle level.
  func getPuzzleQuestions(completionHandler: (results: AnyObject?, errorString: String?) -> Void) {
    if let _ = PBClient.puzzleLevel {
      
      /// Retrieve the sub-puzzle group via the PB Network Layer
      pbNet.doParseGetReq(PBClient.puzzleGroup!) { result, error in
        if let inError = error {
          completionHandler(results: nil, errorString: inError.localizedDescription)
        } else {
          completionHandler(results: result, errorString: nil)
        }
      }
    } else {
      completionHandler(results: nil, errorString: "Invalid puzzle question \(PBClient.puzzleGroup)")
    }
  }
  
  /// Get the puzzle equation for the puzzle item in the puzzle group.
  func getPuzzleEquation(completionHandler: (results: AnyObject?, errorString: String?) -> Void) {
    if let _ = PBClient.questionId {
      
      /// Retrieve the sub-puzzle group via the PB Network Layer
      pbNet.doParseGetReq(PBClient.questionId!) { result, error in
        if let inError = error {
          completionHandler(results: nil, errorString: inError.localizedDescription)
        } else {
          completionHandler(results: result, errorString: nil)
        }
      }
    } else {
      completionHandler(results: nil, errorString: "Invalid puzzle question \(PBClient.puzzleGroup)")
    }
  }
  
  /// Get the puzzle meta data for the total number of puzzles, and the score levels
  func getPuzzleMeta(completionHandler: (results: AnyObject?, errorString: String?) -> Void) {
    /// Retrieve the sub-puzzle group via the PB Network Layer
    pbNet.doParseGetReq(PBClient.ParseMethods.PuzzleMeta) { result, error in
      if let inError = error {
        completionHandler(results: nil, errorString: inError.localizedDescription)
      } else {
        completionHandler(results: result, errorString: nil)
      }
    }
  }
  
  /// Determine all answers to the puzzle given the list of variables
  func getPuzzleAnswers(question: NSArray?, variables: NSArray?) -> NSArray {
    let answers : NSMutableArray = []
    if question != nil && variables != nil {
      for variable in variables! {
        var answer:Int = 0
        var count:Int = 0
        for operand in question! {
          if operand as! String == "?" {
            if count == 0 {
              answer = Int(variable as! Int)
            } else {
              answer = PBClient.doOperator(answer, valueB: Int(variable as! Int))!
            }
          } else {
            if count == 0 {
              answer = Int(operand.integerValue as Int)
            } else {
              answer = PBClient.doOperator(answer, valueB: Int(operand.integerValue as Int))!
            }
          }
          count += 1
        }
        answers.insertObject(answer, atIndex: answers.count)
      }
    }
    return answers as NSArray
  }
  
  
  /// Check the input answers for correctness
  func checkPuzzleAnswers() -> Bool {
    var i = 0;
    var res = true
    for (i = 0; i < PBClient.answers!.count; i++) {
      if Int(PBClient.answers![i] as! NSNumber) != Int(PBClient.selectedAnswers![i] as! NSNumber) {
        res = false
        break
      }
    }
    return res
  }
  
  /// Retrieve stored users from CoreData
  func retrieveUsers() -> NSArray {
  
    // Retrieve the users that are stored
    do {
      try self.fetchedResultsController.performFetch()
  
      let users = fetchedResultsController.fetchedObjects! as NSArray
      return users
    } catch {
      return []
    }
  }
}

