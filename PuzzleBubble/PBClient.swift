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
  
  static let sharedInstance = PBClient()
  
  /// initialise and create a Puzzle Bubble Network Layer
  override init() {
    pbNet = PBNetLayer()
    super.init()
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
  
  /// Get the puzzle equation for the puzzle item in the puzzle group.
  func getPuzzleEquation(puzzleGroup:Int, puzzleItem:Int) -> String {
    let equation:String = "Unknown"
    
    // @TODO retrieve the puzzle equation
    
    return equation
  }
  
}

