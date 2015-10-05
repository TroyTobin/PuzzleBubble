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

  /// Return the number of grid items to display
  ///
  /// :param: collectionView The collection view controller
  /// :param: section The index into the collection view
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return MAX_GRID_ELEMENTS
  }
  
  /// Return the grid item for the desired index
  ///
  /// :param: collectionView The collection view controller
  /// :param: indexPath The index of the item in the collection view
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let gridCell = collectionView.dequeueReusableCellWithReuseIdentifier("gridCell", forIndexPath: indexPath) as! GridViewCell
    gridCell.layer.cornerRadius = 10
    return gridCell
  }
}
