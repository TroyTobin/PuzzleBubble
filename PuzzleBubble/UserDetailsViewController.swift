//
//  UserDetailsViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 6/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
  
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userScoreLabel: UILabel!
  @IBOutlet weak var userScore: UILabel!
  @IBOutlet weak var userLevelLabel: UILabel!
  @IBOutlet weak var userLevel: UILabel!
  @IBOutlet weak var userCompletionLabel: UILabel!
  @IBOutlet weak var userCompletion: UILabel!
  @IBOutlet weak var userGender: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.layer.cornerRadius = 10
  }
  
  override func viewWillAppear(animated: Bool) {
    
    self.view.backgroundColor = UIColor.whiteColor()
    let textFontAttributes = [
      NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 10.0)!,
      NSForegroundColorAttributeName: UIColor.whiteColor(),
      NSStrokeColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
      NSStrokeWidthAttributeName: -7
    ]
    
    let scoreLabel = NSAttributedString(string: "Score", attributes: textFontAttributes)
    userScoreLabel.attributedText = scoreLabel
    let levelLabel = NSAttributedString(string: "Level", attributes: textFontAttributes)
    userLevelLabel.attributedText = levelLabel
    let completionLabel = NSAttributedString(string: "Completion", attributes: textFontAttributes)
    userCompletionLabel.attributedText = completionLabel
    
    if let currentUser = PBClient.currentUser {
      let nameFontAttributes = [
        NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 20.0)!,
        NSForegroundColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
        NSStrokeColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
        NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleDouble.rawValue,
      ]
      
      let nameLabel = NSAttributedString(string: "\(currentUser.name)", attributes: nameFontAttributes)

      userName.attributedText = nameLabel
      print ("gender = '\(currentUser.gender)'")
      if (currentUser.gender == "male") {
        userGender.image = UIImage(named: "man")
      } else {
        userGender.image = UIImage(named: "woman")
      }
    }
  }
}