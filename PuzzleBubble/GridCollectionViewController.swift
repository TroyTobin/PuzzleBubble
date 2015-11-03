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
    print ("PBClient.selectedAnswers?.count \(PBClient.selectedAnswers?.count)")
    print ("PBClient.answers?.count \(PBClient.answers?.count)")
    print ("=== \(PBClient.answers?.count != PBClient.selectedAnswers?.count)")
    if (PBClient.selectedAnswers?.count != PBClient.answers?.count) {
      // @TODO Replace this with useful data
      // Get a random index into the answers array
      print ("re-order")
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
      print("setting background")
      if (PBClient.selectedAnswers?.count == PBClient.answers?.count) {
        print("Red or green")
        if (PBClient.correct) {
          print ("Green")
          gridCell.gridLabel.backgroundColor = UIColor.greenColor()
        } else {
          print ("Red")
          gridCell.gridLabel.backgroundColor = UIColor.redColor()
        }
      } else {
        print ("Blue")
        gridCell.gridLabel.backgroundColor = UIColor.blueColor()
      }
    } else {
      print ("setting background to black")
      gridCell.gridLabel.backgroundColor = UIColor.blackColor()
    }
    return gridCell
  }
  
  /// View the selected meme in the MemeViewController
  ///
  /// :param: collectionView The collection view controller
  /// :param: indexPath The index of the item selected
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
    print("selected \(indexPath.row)")
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GridViewCell
    
    cell.gridLabel.backgroundColor = UIColor.blueColor()
    PBClient.selectedAnswersOrder!.insertObject(indexPath.row, atIndex: 0)
    PBClient.selectedAnswers!.insertObject(Int(cell.gridLabel.text!)!, atIndex: (PBClient.selectedAnswers?.count)!)
    print("selectedAnswers count = \(PBClient.selectedAnswers?.count)")
    print("answers count = \(PBClient.answers?.count)")
    // If all tiles have been selected check the results order for conformance
    if (PBClient.selectedAnswers?.count == PBClient.answers?.count) {
      print ("check answers")
      PBClient.correct = PBClient.sharedInstance.checkPuzzleAnswers()
      print ("Correct? = \(PBClient.correct)")
      dispatch_async(dispatch_get_main_queue(), {
        collectionView.reloadData()
      })
      
    }
  }
}
