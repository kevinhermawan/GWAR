//
//  UIViewController+Child.swift
//  GWAR
//
//  Created by Kevin Hermawan on 04/07/21.
//

import UIKit

extension UIViewController {
  func addViewControllerChild(_ child: UIViewController) {
    addChild(child)
    child.view.frame = view.frame
    view?.addSubview(child.view)
    child.didMove(toParent: self)
  }
  
  func removeViewControllerChild(_ child: UIViewController) {
    child.willMove(toParent: nil)
    child.view.removeFromSuperview()
    child.removeFromParent()
  }
}
