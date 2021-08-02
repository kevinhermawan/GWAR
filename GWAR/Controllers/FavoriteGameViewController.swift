//
//  FavoriteGameViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 01/08/21.
//

import UIKit
import CoreData

class FavoriteGameViewController: UIViewController {
  
  private let favoriteGameCoreData = FavoriteGameCoreData()
  private let loadingViewController = LoadingViewController()
  private let favoriteEmptyViewController = FavoriteEmptyViewController()
  
  private var games = [GameForCoreData]()
  
  var gameView: GameView? {
    return self.view as? GameView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Favorites"
  }
  
  override func loadView() {
    super.loadView()
    
    let view = GameView(frame: self.view.frame)
    view.tableViewDelegate = self
    view.tableViewDataSource = self
    
    self.view = view
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let gamesFromCoreData = favoriteGameCoreData.retrieve()
    games = gamesFromCoreData
        
    checkSizeOfGames()
    gameView?.tableView.reloadData()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    games = []
  }
  
  func checkSizeOfGames() {
    if games.count < 1 {
      addViewControllerChild(favoriteEmptyViewController)
    } else {
      removeViewControllerChild(favoriteEmptyViewController)
    }
  }
}

// MARK: - Table View Delegate & Data Source
extension FavoriteGameViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return games.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = GameTableViewCell.reuseIdentifier
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? GameTableViewCell
    
    let game = games[indexPath.row]
    
    if let backgroundImage = game.backgroundImage {
      let imageURL = URL(string: backgroundImage)
      
      cell?.backgroundImageView.kf.indicatorType = .activity
      cell?.backgroundImageView.kf.setImage(with: imageURL)
    }
    
    cell?.genreLabel.text = game.genre
    cell?.nameLabel.text = game.name
    cell?.ratingLabel.text = game.rating
    cell?.releaseDateLabel.text = game.releaseDate
    
    return cell ?? UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let game = games[indexPath.row]
    
    let removeAction = UIContextualAction(style: .destructive, title: nil) { [weak self, indexPath] (_, _, _) in
      guard let strongSelf = self else { return }
      
      if let gameID = game.id {
        strongSelf.favoriteGameCoreData.delete(id: gameID)
        strongSelf.games.removeAll(where: { $0.id == gameID })
        strongSelf.checkSizeOfGames()
        strongSelf.gameView?.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
    removeAction.backgroundColor = .systemRed
    removeAction.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 25)).image { _ in
      UIImage(systemName: "trash")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 25))
    }
    
    return UISwipeActionsConfiguration(actions: [removeAction])
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let vc = GameDetailsViewController()
    vc.hidesBottomBarWhenPushed = true
    
    let game = games[indexPath.row]
    vc.gameID = Int(game.id ?? 0)
    
    navigationController?.pushViewController(vc, animated: true)
  }
}
