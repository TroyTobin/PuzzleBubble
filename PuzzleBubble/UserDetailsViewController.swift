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
  @IBOutlet weak var levelActivity: UIActivityIndicatorView!
  @IBOutlet weak var completionActivity: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.layer.cornerRadius = 10
    
    self.view.backgroundColor = UIColor.whiteColor()
    let textFontAttributes = [
      NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 10.0)!,
      NSForegroundColorAttributeName: UIColor.whiteColor(),
      NSStrokeColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
      NSStrokeWidthAttributeName: -7
    ]
    
    let levelLabel = NSAttributedString(string: "Level", attributes: textFontAttributes)
    userLevelLabel.attributedText = levelLabel
    let completionLabel = NSAttributedString(string: "Completion", attributes: textFontAttributes)
    userCompletionLabel.attributedText = completionLabel
    let scoreLabel = NSAttributedString(string: "Score", attributes: textFontAttributes)
    userScoreLabel.attributedText = scoreLabel
    
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadUserStats:", name: "reloadUserStats",object: nil)

  }
  
  override func viewWillAppear(animated: Bool) {
    
    
    if let currentUser = PBClient.currentUser {
      let nameFontAttributes = [
        NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 20.0)!,
        NSForegroundColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
        NSStrokeColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
        NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleDouble.rawValue,
      ]
      
      let nameLabel = NSAttributedString(string: "\(currentUser.name)", attributes: nameFontAttributes)

      userName.attributedText = nameLabel
      
      let scoreFontAttributes = [
        NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 16.0)!,
        NSForegroundColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
      ]
      
      let scoreLabel = NSAttributedString(string: "\(currentUser.score)", attributes: scoreFontAttributes)
      userScore.attributedText = scoreLabel
      
      
      if (currentUser.gender == "male") {
        userGender.image = UIImage(named: "man")
      } else {
        userGender.image = UIImage(named: "woman")
      }
    }
  }
  
  func reloadUserStats(notification: NSNotification) {
    print ("reload stats")
    
    let scoreFontAttributes = [
      NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 16.0)!,
      NSForegroundColorAttributeName: UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0),
    ]
    
    let num_solved = (PBClient.currentUser?.completed.count)! as Int
    print("\(num_solved)/\(PBClient.num_puzzles)")
    let completionLabel = NSAttributedString(string: "\(num_solved)/\(PBClient.num_puzzles)", attributes: scoreFontAttributes)
    dispatch_async(dispatch_get_main_queue(), {
      self.completionActivity.hidden = true
      self.userCompletion.attributedText = completionLabel
    })
    
    let score = PBClient.currentUser?.score as! Int
    let levels = PBClient.score_levels
    var levelIndex = 1
    for level in levels! {
      let _level = level as! Int
      if score < _level {
        break
      } else {
        levelIndex += 1
      }
    }
    let level_text = PBClient.score_text![levelIndex] as! String
    print("\(level_text)")
    let levelTextLabel = NSAttributedString(string: "\(level_text)", attributes: scoreFontAttributes)
    
    dispatch_async(dispatch_get_main_queue(), {
      self.levelActivity.hidden = true
      self.userLevel.attributedText = levelTextLabel
    })
  }
}