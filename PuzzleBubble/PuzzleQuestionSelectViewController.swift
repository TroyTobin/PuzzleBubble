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
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
        
    /// notify listeners they can use the data
    NSNotificationCenter.defaultCenter().postNotificationName("reloadLevelQuestions", object: nil)

  }
  
  /// Dismiss this view controller
  @IBAction func dismissView(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}