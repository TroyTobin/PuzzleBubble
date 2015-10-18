//
//  PuzzleViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 5/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {

  @IBOutlet weak var PuzzleQuestion: UILabel!
  @IBOutlet weak var PuzzleVariables: UITextView!
  
  var puzzleGroup:Int? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()

    print("puzzleGroup selected = \(self.puzzleGroup)")
  }
}

