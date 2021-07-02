//
//  GameViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit

class GameViewController: UIViewController {
  
  private let loadingViewController = LoadingViewController()
  
  private var gameView: GameView? {
    return self.view as? GameView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
    
    addViewControllerChild(loadingViewController)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.removeViewControllerChild(self.loadingViewController)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    tabBarController?.title = "Games"
    tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func loadView() {
    super.loadView()
    
    let view = GameView(frame: self.view.frame)
    
    self.view = view
  }
}
