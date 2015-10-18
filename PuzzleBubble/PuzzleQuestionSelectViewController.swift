//
//  PuzzleQuestionSelectViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 18/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import Foundation
import UIKit

class PuzzleQuestionSelectViewController: UIViewController {
  

  @IBOutlet weak var puzzleQuestionList: UIView!
  
  var puzzleLevel: Int? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    /// Set the puzzleLevel in the PB Client so it can
    /// be used for further queries
    PBClient.puzzleLevel = puzzleLevel
        
    /// notify listeners they can use the data
    NSNotificationCenter.defaultCenter().postNotificationName("reloadLevelQuestions", object: nil)

  }
}