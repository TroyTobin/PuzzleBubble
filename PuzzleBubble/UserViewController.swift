//
//  UserViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 6/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit
import CoreData

class UserViewController: UIViewController, NSFetchedResultsControllerDelegate {

  @IBOutlet weak var userView: UIView!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var newUser: UIButton!

  /// Managed object context
  var sharedContext: NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  /// Fetch controller to retrieve managed obejcts
  lazy var fetchedResultsController: NSFetchedResultsController = {
    
    let fetchRequest = NSFetchRequest(entityName: "User")
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
      managedObjectContext: self.sharedContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    return fetchedResultsController
    
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
    self.userView.layer.cornerRadius = 10
    self.userView.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.userView.layer.borderWidth = 2.0;
    self.playButton.backgroundColor = UIColor.whiteColor()
    self.playButton.layer.cornerRadius = 10
    self.playButton.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.playButton.titleLabel?.textColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0)
    self.playButton.layer.borderWidth = 2.0;
    self.newUser.titleLabel?.textColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0)
    self.newUser.backgroundColor = UIColor.whiteColor()
    self.newUser.layer.cornerRadius = 10
    self.newUser.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    self.newUser.layer.borderWidth = 2.0;
    self.newUser.titleLabel?.textColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0)
    self.userView.hidden = true
    self.playButton.hidden = true
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Retrieve the users that are stored
    
    /// This class is the FetchedResultsController delegate
    fetchedResultsController.delegate = self
    do {
      try self.fetchedResultsController.performFetch()
        
      let users = fetchedResultsController.fetchedObjects! as NSArray
      for user in users {
        let _user = user as! User
        print("user name = \(_user.name)")
        print("user gender = \(_user.gender)")
      }
    } catch {
      
    }
    if let _ = PBClient.currentUser {
      self.userView.hidden = false
      self.playButton.hidden = false
    }
  }
}

