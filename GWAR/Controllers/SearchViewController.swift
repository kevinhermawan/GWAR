//
//  SearchViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit

class SearchViewController: UIViewController {
  
  private let loadingViewController = LoadingViewController()
  
  private var searchView: SearchView? {
    return self.view as? SearchView
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
    
    tabBarController?.title = "Search"
    tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func loadView() {
    super.loadView()
    
    let view = SearchView(frame: self.view.frame)
    
    self.view = view
  }
}
