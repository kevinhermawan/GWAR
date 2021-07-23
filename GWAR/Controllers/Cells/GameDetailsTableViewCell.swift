//
//  GameDetailsTableViewCell.swift
//  GWAR
//
//  Created by Kevin Hermawan on 23/07/21.
//

import UIKit

class GameDetailsTableViewCell: UITableViewCell {
  
  static let reuseIdentifier = "GameDetailsTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    textLabel?.textColor = .systemOrange
    textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    
    detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
