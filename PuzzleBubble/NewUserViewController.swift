//
//  NewUserViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 7/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//
import UIKit
import CoreData

/// View controller for creating a new user
class NewUserViewController: UIViewController {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var input: UITextField!
  @IBOutlet weak var maleButton: UIButton!
  @IBOutlet weak var femaleButton: UIButton!
  @IBOutlet weak var playButton: UIButton!
  
  var tapRecognizer: UITapGestureRecognizer?
  
  var name: String? = nil
  var gender: String? = nil
  
  /// Managed object context
  var sharedContext: NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// Set some consistent style - should really be some helper function....
    input.backgroundColor = UIColor.whiteColor()
    input.layer.cornerRadius = 10
    input.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    input.layer.borderWidth = 2.0;
    
    maleButton.backgroundColor = UIColor.whiteColor()
    maleButton.layer.cornerRadius = 10
    maleButton.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    maleButton.layer.borderWidth = 2.0;
    
    femaleButton.backgroundColor = UIColor.whiteColor()
    femaleButton.layer.cornerRadius = 10
    femaleButton.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    femaleButton.layer.borderWidth = 2.0;
    
    playButton.backgroundColor = UIColor.whiteColor()
    playButton.layer.cornerRadius = 10
    playButton.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    playButton.layer.borderWidth = 2.0;
    playButton.titleLabel?.textColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0)
    
    view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
    
    /// dismiss the keyboard with single tap
    tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
    tapRecognizer?.numberOfTapsRequired = 1
    addKeyboardDismissRecognizer()
    
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.removeKeyboardDismissRecognizer()
  }
  
  /// add the keyboard dismiss recogniser
  func addKeyboardDismissRecognizer() {
    self.view.addGestureRecognizer(tapRecognizer!)
  }
  
  /// remove the keyboard dismiss recogniser
  func removeKeyboardDismissRecognizer() {
    self.view.removeGestureRecognizer(tapRecognizer!)
  }
  
  /// dismiss the keyboard (end editiing) with single tap gesture
  func handleSingleTap(recognizer: UITapGestureRecognizer) {
    self.view.endEditing(true)
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
