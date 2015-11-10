//
//  PuzzleListViewCell.swift
//  PuzzleBubble
//
//  Created by Troy Tobin on 18/10/2015.
//  Copyright © 2015 ttobin. All rights reserved.
//

import UIKit

class PuzzleListViewCell: UITableViewCell {
  var id: Int? = nil
  var puzzle: String? = nil
  var prose: String? = nil
  @IBOutlet weak var activity: UIActivityIndicatorView!
  
}