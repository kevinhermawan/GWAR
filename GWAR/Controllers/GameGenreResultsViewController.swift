//
//  GameGenreResultsViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 01/08/21.
//

import UIKit

class GameGenreResultsViewController: UIViewController {
  
  private let favoriteGameCoreData = FavoriteGameCoreData()
  private let loadingViewController = LoadingViewController()
  
  var genre: GameGenre?
  private var games = [Game]()
  private var favoriteGameIds = [Int]()
  
  var gameView: GameView? {
    return self.view as? GameView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = genre?.name
    
    fetchGames()
    retrieveGameFavoriteIds()
  }
  
  override func loadView() {
    super.loadView()
    
    let view = GameView(frame: self.view.frame)
    view.tableViewDelegate = self
    view.tableViewDataSource = self
    
    self.view = view
  }
}

// MARK: - Data Fetching
extension GameGenreResultsViewController {
  func fetchGames() {
    addViewControllerChild(loadingViewController)
    
    let urlRequest = URLRequest.getGamesURL(page: 1, genreID: genre?.id ?? 0)
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
        print("fetchGames - ERROR:", error)
      }
    }
    
    task.resume()
  }
}

// MARK: - Table View Delegate & Data Source
extension GameGenreResultsViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    let genre = game.genres?.map({ $0.name }).joined(separator: ", ")
    let name = game.name.withRatingEmoticon(rating: game.ratings?.first?.title)
    let rating = "??? \(game.rating ?? 0.0)"
    let releaseDate = game.released?.formatReleaseDate(tba: game.tba)
    
    cell?.genreLabel.text = genre
    cell?.nameLabel.text = name
    cell?.ratingLabel.text = rating
    cell?.releaseDateLabel.text = releaseDate
    
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
}

// MARK: - Core Data
extension GameGenreResultsViewController {
  func retrieveGameFavoriteIds() {
    let gameFromCoreData = favoriteGameCoreData.retrieve()
    
    favoriteGameIds = gameFromCoreData.map({ Int($0.id ?? 0) })
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
