//
//  PBNetLayer.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 11/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import Foundation

// This class provides an api layer for performing http requests to Parse
class PBNetLayer: NSObject {
  
  var session: NSURLSession
  
  /// Initialise the Network Layer
  override init() {
    session = NSURLSession.sharedSession()
  }

  /// Get the puzzle groups available.
  /// This retrieves the puzzle groups using the Parse API
  func parseGetPuzzleGroups() -> NSArray? {
    let puzzleGroups:NSMutableArray = NSMutableArray()
    
    /// TODO: actually get the puzzle groups
    return puzzleGroups as NSArray
    
  }
  
  /// Get the puzzle equation for the puzzle item in the puzzle group.
  /// This retrieves the equation using the Parse API
  func parseGetPuzzleEquation(puzzleGroup:Int, puzzleItem:Int) -> String {
    var equation:String = "Unknown"
    
    /// TODO: actually get the equation
    equation = ""
    
    return equation
  }
  

  
}