//
//  PuzzleSubSelectViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 18/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import Foundation
import UIKit

class PuzzleSubSelectViewController: UIViewController {
  

  @IBOutlet weak var subPuzzleGroupList: UIView!
  
  
  var puzzleGroup: String? = nil
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
    
    /// Set the puzzle group in the PB Client so it can 
    /// be used for further queries
    PBClient.puzzleGroup = puzzleGroup
    
    /// notify listeners they can use the data
    NSNotificationCenter.defaultCenter().postNotificationName("reloadSubPuzzles", object: nil)
    
  }
  
  /// Dismiss this view controller
  @IBAction func dismissView(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
}
