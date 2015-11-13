//
//  AboutView.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 9/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//
import Foundation
import UIKit

/// View controller dto display "about" information
class AboutViewController: UIViewController {
  
  @IBOutlet weak var aboutText: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
    aboutText.layer.cornerRadius = 10
    aboutText.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    aboutText.layer.borderWidth = 2.0;
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.Center
    
    let settingsFontAttributes = [
      NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 18.0)!,
      NSForegroundColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
      NSParagraphStyleAttributeName: paragraphStyle
    ]
    var about = "DEVELOPED BY\n"
    about    += "Troy Tobin\n\n\n"
    about    += "I hope you enjoy!\n\n"
    about    += "(C) 2015 Troy Tobin"
    let aboutLabel = NSAttributedString(string: about, attributes: settingsFontAttributes)
    aboutText.attributedText = aboutLabel
  }
  
  @IBAction func dismissView(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
