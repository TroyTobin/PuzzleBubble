//
//  PBConstants.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 11/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import Foundation

//// Sets constants for the Puzzle Bubble Client in this extension
extension PBClient {
  
  // MARK: - Constants
  struct Constants {
    static let ParseAPIKey     = "PUT KEY HERE"
    static let ParseRESTAPIKey = "PUT KEY HERE"
    
    static let ParseBaseURL    = "https://api.parse.com/1/classes"
  }
  
  // MARK: - Puzzle Bubble Methods
  struct ParseMethods {
    static let PuzzleGroups = "PuzzleGroups"
    static let PuzzleGroup  = "PuzzleGroup"
    static let PuzzleItem   = "PuzzleItem"
    static let PuzzleMeta   = "PuzzleMeta"
  }
}