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
    
    self.collectionView.layer.cornerRadius = 10
    self.view.backgroundColor = UIColor(red:0.75, green:0.80, blue:0.90, alpha:1)
    /// Set the notification handler for reloading the question
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadAnswers:", name: "reloadAnswers",object: nil)
  }
  
  func reloadAnswers(notification: NSNotification) {
    PBClient.answersOrder = []
    PBClient.selectedAnswers = []
    PBClient.selectedAnswersOrder = []
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
    if (PBClient.selectedAnswers?.count != PBClient.answers?.count) {
      // Get a random index into the answers array
      var randIndex = Int(arc4random_uniform(UInt32((PBClient.answers?.count)!)))
      while ((PBClient.answersOrder?.containsObject(randIndex))! == true) {
        randIndex = Int(arc4random_uniform(UInt32((PBClient.answers?.count)!)))
      }
      PBClient.answersOrder!.insertObject(randIndex, atIndex: (PBClient.answersOrder?.count)!)
      gridCell.gridLabel.text = "\(PBClient.answers![randIndex])"
      gridCell.activity.hidden = true
    }
    else {
      gridCell.gridLabel.text = "\(PBClient.answers![PBClient.answersOrder![indexPath.row] as! Int)"
    }
    gridCell.gridLabel.textColor = UIColor.whiteColor()
    gridCell.layer.borderWidth = 2
    gridCell.layer.borderColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0).CGColor
    
    if ((PBClient.selectedAnswersOrder?.containsObject(indexPath.row))! == true) {
      if (PBClient.selectedAnswers?.count == PBClient.answers?.count) {
        if (PBClient.correct) {
          gridCell.gridLabel.backgroundColor = UIColor(red:0.30, green:0.95, blue:0.40, alpha:1.0)
        } else {
          gridCell.gridLabel.backgroundColor = UIColor(red:0.95, green:0.30, blue:0.15, alpha:1.0)
        }
      } else {
        gridCell.gridLabel.backgroundColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0)
      }
    } else {
      gridCell.gridLabel.backgroundColor = UIColor.whiteColor()
      gridCell.gridLabel.textColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0)
    }
    return gridCell
  }
  
  /// View the selected meme in the MemeViewController
  ///
  /// :param: collectionView The collection view controller
  /// :param: indexPath The index of the item selected
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GridViewCell
    cell.gridLabel.textColor = UIColor.whiteColor()
    cell.gridLabel.backgroundColor = UIColor(red:0.10, green:0.15, blue:0.35, alpha:1.0)
    if (((PBClient.selectedAnswersOrder?.containsObject(indexPath.row)) == false)) {
      PBClient.selectedAnswersOrder!.insertObject(indexPath.row, atIndex: 0)
      PBClient.selectedAnswers!.insertObject(Int(cell.gridLabel.text!)!, atIndex: (PBClient.selectedAnswers?.count)!)
      // If all tiles have been selected check the results order for conformance
      if (PBClient.selectedAnswers?.count == PBClient.answers?.count) {
        PBClient.correct = PBClient.sharedInstance.checkPuzzleAnswers()
        
        // notify the puzzle view that the user has finished selecting the answers
        NSNotificationCenter.defaultCenter().postNotificationName("problemSolved", object: nil)
    
        dispatch_async(dispatch_get_main_queue(), {
          collectionView.reloadData()
        })
      }
    }
  }
}
