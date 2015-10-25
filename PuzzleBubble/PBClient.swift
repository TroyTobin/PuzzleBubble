//
//  PBClient.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 11/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import Foundation

/// This class represents the Puzzle Bubble API to the View controllers
class PBClient: NSObject {
  
  var pbNet:PBNetLayer
  
  static var puzzleGroup: String? = nil
  static var puzzleLevel: Int? = nil
  static var questionId: String? = nil
  static var question: NSArray? = nil
  static var variables: NSArray? = nil
  static var answers: NSArray? = nil
  static var answersOrder: NSMutableArray? = nil
  
  static let sharedInstance = PBClient()
  
  /// initialise and create a Puzzle Bubble Network Layer
  override init() {
    pbNet = PBNetLayer()
    super.init()
  }
  
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
        print("puzzlegroups = \(result)")
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
    print ("getPuzzleQuestions - puzzleLevel = \(PBClient.puzzleLevel)")
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
  
  func getPuzzleAnswers(question: NSArray?, variables: NSArray?) -> NSArray {
    let answers : NSMutableArray = []
    if question != nil && variables != nil {
      for variable in variables! {
        print ("variable = \(variable)")
        var answer:Int = 0
        for operand in question! {
          print ("operand = \(operand)")
          if operand as! String == "?" {
            answer = PBClient.doOperator(answer, valueB: Int(variable as! Int))!
          } else {
            answer = PBClient.doOperator(answer, valueB: Int(operand.integerValue as Int))!
          }
        }
        answers.insertObject(answer, atIndex: answers.count)
      }
    }
    return answers as NSArray
  }
}

