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
    }
    else {
      gridCell.gridLabel.text = "\(PBClient.answers![PBClient.answersOrder![indexPath.row] as! Int)"
    }
    if ((PBClient.selectedAnswersOrder?.containsObject(indexPath.row))! == true) {
      if (PBClient.selectedAnswers?.count == PBClient.answers?.count) {
        if (PBClient.correct) {
          gridCell.gridLabel.backgroundColor = UIColor.greenColor()
        } else {
          gridCell.gridLabel.backgroundColor = UIColor.redColor()
        }
      } else {
        gridCell.gridLabel.backgroundColor = UIColor.blueColor()
      }
    } else {
      gridCell.gridLabel.backgroundColor = UIColor.blackColor()
    }
    return gridCell
  }
  
  /// View the selected meme in the MemeViewController
  ///
  /// :param: collectionView The collection view controller
  /// :param: indexPath The index of the item selected
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GridViewCell
    
    cell.gridLabel.backgroundColor = UIColor.blueColor()
    PBClient.selectedAnswersOrder!.insertObject(indexPath.row, atIndex: 0)
    PBClient.selectedAnswers!.insertObject(Int(cell.gridLabel.text!)!, atIndex: (PBClient.selectedAnswers?.count)!)
    // If all tiles have been selected check the results order for conformance
    if (PBClient.selectedAnswers?.count == PBClient.answers?.count) {
      PBClient.correct = PBClient.sharedInstance.checkPuzzleAnswers()
      dispatch_async(dispatch_get_main_queue(), {
        collectionView.reloadData()
      })
      
    }
  }
}
