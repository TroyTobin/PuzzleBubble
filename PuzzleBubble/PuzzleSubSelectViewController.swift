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
    
    /// Set the puzzle group in the PB Client so it can 
    /// be used for further queries
    PBClient.puzzleGroup = puzzleGroup
    
    /// notify listeners they can use the data
    NSNotificationCenter.defaultCenter().postNotificationName("reloadSubPuzzles", object: nil)
    
  }
}
