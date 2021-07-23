//
//  UIButton+UnderlineTitle.swift
//  GWAR
//
//  Created by Kevin Hermawan on 23/07/21.
//

import UIKit

extension UIButton {
  func setUnderlineTitle(title: String) {
    let attributedString = NSAttributedString(string: NSLocalizedString(title, comment: ""), attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0),
      NSAttributedString.Key.foregroundColor: UIColor.systemGray,
      NSAttributedString.Key.underlineStyle: 1.0
    ])
    
    self.setAttributedTitle(attributedString, for: .normal)
  }
}
