//
//  Question.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 5/11/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit
import CoreData

/// Question is a managed object
class Question : NSManagedObject {
  
  struct Keys {
    static let Id  = "Identifier"
  }
  
  ///Set the Question attributes to Core data attributes
  @NSManaged var id: String
  
  
  /// initialise the Core data
  override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    super.init(entity: entity, insertIntoManagedObjectContext: context)
  }
  
  /// Initialise the pin with a dictionary
  init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
    
    // Get the entity associated with the Pin type
    let entity =  NSEntityDescription.entityForName("Question", inManagedObjectContext: context)!
    
    // Init for Managed object - this will store the object
    super.init(entity: entity,insertIntoManagedObjectContext: context)
    
    // Set the Question attributes
    id = dictionary[Keys.Id] as! String
  }
}