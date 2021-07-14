//
//  UIImageView+Rounded.swift
//  GWAR
//
//  Created by Kevin Hermawan on 14/07/21.
//

import UIKit

extension UIImageView {
  func setRounded(radius: CGFloat) {
    self.layer.masksToBounds = true
    self.layer.cornerRadius = radius
  }
}
