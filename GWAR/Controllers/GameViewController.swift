//
//  GameViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit
import CoreData
import Kingfisher

class GameViewController: UIViewController {
  
  private let favoriteGameCoreData = FavoriteGameCoreData()
  private let loadingViewController = LoadingViewController()
  
  private var games = [Game]()
  private var favoriteGameIds = [Int]()
  
  var gameView: GameView? {
    return self.view as? GameView
  }
  
  override func viewDidAppear(_ animated: Bool) {
    fetchGameFavoriteIds()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    favoriteGameIds = []
  }
  
  override func loadView() {
    super.loadView()
    
    let view = GameView(frame: self.view.frame)
    view.tableViewDelegate = self
    view.tableViewDataSource = self
    
    self.view = view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Games"
    
    fetchGames()
  }
}

// MARK: - Data Fetching
extension GameViewController {
  func fetchGames() {
    addViewControllerChild(loadingViewController)
    
    let urlRequest = URLRequest.getGamesURL(page: 1)
    let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
      guard let strongSelf = self else { return }
      
      do {
        guard let data = data else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decoded = try decoder.decode(APIResponse<[Game]>.self, from: data)
        
        DispatchQueue.main.async {
          strongSelf.games = decoded.results
          strongSelf.gameView?.tableView.reloadData()
          strongSelf.removeViewControllerChild(strongSelf.loadingViewController)
        }
      } catch {
        fatalError("fetchGames Error: \(error)")
      }
    }
    
    task.resume()
  }
}

// MARK: - Table View Delegate & Data Source
extension GameViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return games.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = GameTableViewCell.reuseIdentifier
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? GameTableViewCell
    
    let game = games[indexPath.row]
    
    if let backgroundImage = game.backgroundImage {
      let imageURL = URL(string: backgroundImage)
      
      setGameTableViewCellImage(cell: cell, imageURL: imageURL)
    }
    
    setGameTableViewCellLabels(cell: cell, game: game)
    
    return cell ?? UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let game = games[indexPath.row]
    let isFavorited = favoriteGameIds.contains(game.id)
    
    let favoriteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, _) in
      guard let strongSelf = self else { return }
      
      if isFavorited {
        strongSelf.deleteGameFromFavorite(id: game.id)
      } else {
        strongSelf.saveGameToFavorite(game: game)
      }
    }
    
    favoriteAction.backgroundColor = .systemPink
    favoriteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 25)).image { _ in
      UIImage(systemName: isFavorited ? "heart.fill" : "heart")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 25))
    }
    
    return UISwipeActionsConfiguration(actions: [favoriteAction])
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let vc = GameDetailsViewController()
    vc.hidesBottomBarWhenPushed = true
    
    let game = games[indexPath.row]
    vc.gameID = game.id
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func setGameTableViewCellImage(cell: GameTableViewCell?, imageURL: URL?) {
    cell?.backgroundImageView.kf.indicatorType = .activity
    cell?.backgroundImageView.kf.setImage(with: imageURL)
  }
  
  func setGameTableViewCellLabels(cell: GameTableViewCell?, game: Game) {
    let genre = game.genres?.map({ $0.name }).joined(separator: ", ")
    let name = game.name.withRatingEmoticon(rating: game.ratings?.first?.title)
    let rating = "⭐ \(game.rating ?? 0.0)"
    let releaseDate = game.released?.formatReleaseDate(tba: game.tba)
    
    cell?.genreLabel.text = genre
    cell?.nameLabel.text = name
    cell?.ratingLabel.text = rating
    cell?.releaseDateLabel.text = releaseDate
  }
}

// MARK: - Core Data
extension GameViewController {
  func fetchGameFavoriteIds() {
    let gameForCoreData = favoriteGameCoreData.retrieve()
    
    favoriteGameIds = gameForCoreData.map({ Int($0.id ?? 0) })
  }
  
  func saveGameToFavorite(game: Game) {
    favoriteGameCoreData.save(game: game)
    favoriteGameIds.append(game.id)
    gameView?.tableView.reloadData()
  }
  
  func deleteGameFromFavorite(id: Int) {
    favoriteGameCoreData.delete(id: Int32(id))
    favoriteGameIds.removeAll(where: { $0 == id })
    gameView?.tableView.reloadData()
  }
}
