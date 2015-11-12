//
//  ChangeUserView.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 9/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import Foundation
import UIKit

/// Class for changing user view controller.
/// This doesn't do much at the moment - just sets the
/// background color and provides a view dismiss.
/// May want to do some custom work on this later
class ChangeUserViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
  }
  
  @IBAction func dismissView(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
