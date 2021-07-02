//
//  AboutViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit

class AboutViewController: UIViewController {
  
  private let loadingViewController = LoadingViewController()
  
  private var aboutView: AboutView? {
    return self.view as? AboutView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addViewControllerChild(loadingViewController)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.removeViewControllerChild(self.loadingViewController)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    tabBarController?.title = "About"
    tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func loadView() {
    super.loadView()
    
    let view = AboutView(frame: self.view.frame)
    
    self.view = view
  }
}
