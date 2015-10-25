//
//  GridCollectionViewController.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 5/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit
import CoreData

let MAX_GRID_ELEMENTS = 9

class GridCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// Set the notification handler for reloading the question
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadAnswers:", name: "reloadAnswers",object: nil)
  }
  
  func reloadAnswers(notification: NSNotification) {
    PBClient.answersOrder = []
    dispatch_async(dispatch_get_main_queue(), {
      self.collectionView.reloadData()
    })
  }
  
  /// Return the number of grid items to display
  ///
  /// :param: collectionView The collection view controller
  /// :param: section The index into the collection view
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if PBClient.answers == nil {
      return 0
    }
    return (PBClient.answers?.count)!
  }
  
  /// Return the grid item for the desired index
  ///
  /// :param: collectionView The collection view controller
  /// :param: indexPath The index of the item in the collection view
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let gridCell = collectionView.dequeueReusableCellWithReuseIdentifier("gridCell", forIndexPath: indexPath) as! GridViewCell
    gridCell.layer.cornerRadius = 10
    
    // @TODO Replace this with useful data
    // Get a random index into the answers array
    var randIndex = Int(arc4random_uniform(UInt32((PBClient.answers?.count)!)))
    while ((PBClient.answersOrder?.containsObject(randIndex))! == true) {
      randIndex = Int(arc4random_uniform(UInt32((PBClient.answers?.count)!)))
    }
    PBClient.answersOrder!.insertObject(randIndex, atIndex: 0)
    gridCell.gridLabel.text = "\(PBClient.answers![randIndex])"
    return gridCell
  }
}
