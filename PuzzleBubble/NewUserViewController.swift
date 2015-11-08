//
//  NewUserViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 7/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//
import UIKit
import CoreData

class NewUserViewController: UIViewController {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var input: UITextField!
  @IBOutlet weak var maleButton: UIButton!
  @IBOutlet weak var femaleButton: UIButton!
  @IBOutlet weak var playButton: UIButton!
  
  var name: String? = nil
  var gender: String? = nil
  
  /// Managed object context
  var sharedContext: NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.input.backgroundColor = UIColor.whiteColor()
    self.input.layer.cornerRadius = 10
    self.input.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.input.layer.borderWidth = 2.0;
    
    self.maleButton.backgroundColor = UIColor.whiteColor()
    self.maleButton.layer.cornerRadius = 10
    self.maleButton.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.maleButton.layer.borderWidth = 2.0;
    
    self.femaleButton.backgroundColor = UIColor.whiteColor()
    self.femaleButton.layer.cornerRadius = 10
    self.femaleButton.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.femaleButton.layer.borderWidth = 2.0;
    
    self.playButton.backgroundColor = UIColor.whiteColor()
    self.playButton.layer.cornerRadius = 10
    self.playButton.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.playButton.layer.borderWidth = 2.0;
    self.playButton.titleLabel?.textColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0)
    
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
  }
  
  @IBAction func selectMale(sender: AnyObject) {
    self.femaleButton.backgroundColor = UIColor.whiteColor()
    self.maleButton.backgroundColor = UIColor(red:0.30, green:0.95, blue:0.40, alpha:1.0)
    gender = "male"
  }
  
  @IBAction func setFemale(sender: AnyObject) {
    self.maleButton.backgroundColor = UIColor.whiteColor()
    self.femaleButton.backgroundColor = UIColor(red:0.30, green:0.95, blue:0.40, alpha:1.0)
    gender = "female"
  }
  
  @IBAction func play(sender: AnyObject) {
    let _name = self.input.text
    if _name != "" {
      if let _gender = gender {
    
        /// Create the user and return to the main screen
        let dictionary: [String : AnyObject] = [
          User.Keys.Name : _name!,
          User.Keys.Gender : _gender,
          User.Keys.Score: 0,
          User.Keys.IsCurrent: true,
        ]
    
        let users = PBClient.sharedInstance.retrieveUsers()
        for user in users {
          let _user = user as! User
          _user.isCurrent = false
        }
        
        /// Now we create a new Person, using the shared Context
        let newUser = User(dictionary: dictionary, context: sharedContext)
        PBClient.currentUser = newUser
        CoreDataStackManager.sharedInstance().saveContext()
        
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }
  
  
}
