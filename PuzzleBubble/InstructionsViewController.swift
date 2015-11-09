//
//  InstructionsViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 9/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//


import Foundation
import UIKit

class InstructionsViewController: UIViewController {
  
  @IBOutlet weak var instructionText: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
    instructionText.layer.cornerRadius = 10
    instructionText.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    instructionText.layer.borderWidth = 2.0;
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.Left
    
    let settingsFontAttributes = [
      NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 14.0)!,
      NSForegroundColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
      NSParagraphStyleAttributeName: paragraphStyle
    ]
    var instructions = "CREATE NEW USER\n"
    instructions += "  1. Create a new user by specifying a\n"
    instructions += "      username and gender.\n\n"
    instructions += "SELECT A PUZZLE TO SOLVE\n"
    instructions += "  1. Select the puzzle type to solve\n"
    instructions += "  2. Select the puzzle level to solve\n"
    instructions += "  3. Select the puzzle question to solve\n\n"
    instructions += "SOLVE THE PUZZLE\n"
    instructions += "  1. The question will be shown as,\n"
    instructions += "                     \"1 + ?\"\n"
    instructions += "  2. A list of variables are shown as,\n"
    instructions += "                     \"? = 2\"\n"
    instructions += "                     \"? = 4\"\n"
    instructions += "  3. For each variable in the list,\n"
    instructions += "      substitute into the quesiton\n"
    instructions += "      and solve,\n"
    instructions += "                     \"1 + 2\" = 3\n"
    instructions += "                     \"1 + 4\" = 5\n"
    instructions += "  4. Enter the answers in the number\n"
    instructions += "      grid in the order the variables appear\n"
    instructions += "  5. A correct sequence will appear GREEN\n"
    instructions += "      An incorrect sequence will appear RED"
    let aboutLabel = NSAttributedString(string: instructions, attributes: settingsFontAttributes)
    instructionText.attributedText = aboutLabel
  }
  
  @IBAction func dismissView(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
