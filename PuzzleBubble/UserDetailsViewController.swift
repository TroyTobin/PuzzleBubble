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
  @IBOutlet weak var userScore: UILabel!
  @IBOutlet weak var userLevel: UILabel!
  @IBOutlet weak var userNextLevel: UILabel!
  @IBOutlet weak var userCompletion: UILabel!
  @IBOutlet weak var userGender: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.layer.cornerRadius = 10
  }
  
  override func viewWillAppear(animated: Bool) {
    if let currentUser = PBClient.currentUser {
      userName.text = currentUser.name
      print ("gender = '\(currentUser.gender)'")
      if (currentUser.gender == "male") {
        userGender.image = UIImage(named: "man")
      } else {
        userGender.image = UIImage(named: "woman")
      }
    }
  }
}