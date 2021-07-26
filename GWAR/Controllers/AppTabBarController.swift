//
//  AppTabBarController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit

class AppTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let gameViewController = UINavigationController(rootViewController: GameViewController())
    let searchViewController = UINavigationController(rootViewController: SearchViewController())
    let aboutViewController = UINavigationController(rootViewController: AboutViewController())
        
    let gameImage = UIImage(systemName: "gamecontroller")
    gameViewController.navigationBar.prefersLargeTitles = true
    gameViewController.tabBarItem = UITabBarItem(title: "Games", image: gameImage, tag: 0)
    
    let searchImage = UIImage(systemName: "magnifyingglass")
    searchViewController.navigationBar.prefersLargeTitles = true
    searchViewController.tabBarItem = UITabBarItem(title: "Search", image: searchImage, tag: 1)
    
    let aboutImage = UIImage(systemName: "person.circle")
    aboutViewController.navigationBar.prefersLargeTitles = true
    aboutViewController.tabBarItem = UITabBarItem(title: "About", image: aboutImage, tag: 2)

    viewControllers = [gameViewController, searchViewController, aboutViewController]
  }
}
