//
//  User.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 5/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit
import CoreData

/// User is a managed object
class User : NSManagedObject {
  
  struct Keys {
    static let Name      = "Name"
    static let Score     = "Score"
    static let Gender    = "Gender"
    static let IsCurrent = "IsCurrent"
  }
  
  ///Set the User attributes to Core data attributes
  @NSManaged var name: String
  @NSManaged var gender: String
  @NSManaged var score: NSNumber
  @NSManaged var isCurrent: Bool
  @NSManaged var completed: [Question]
  
  
  /// initialise the Core data
  override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    super.init(entity: entity, insertIntoManagedObjectContext: context)
  }
  
  /// Initialise the pin with a dictionary
  init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
    
    // Get the entity associated with the Pin type
    let entity =  NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
    
    // Init for Managed object - this will store the object
    super.init(entity: entity,insertIntoManagedObjectContext: context)
    
    // Set the User attributes
    name      = dictionary[Keys.Name] as! String
    gender    = dictionary[Keys.Gender] as! String
    score     = dictionary[Keys.Score] as! NSNumber
    isCurrent = dictionary[Keys.IsCurrent] as! Bool
  }
}