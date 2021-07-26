//
//  GameViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit
import Kingfisher

class GameViewController: UIViewController {
  
  private let loadingViewController = LoadingViewController()
  
  private var games = [Game]()
  
  var isSearchMode = false
  var gamesFromSearch = [Game]()
  
  var genreID: Int?
  var gamesByGenre = [Game]()
  
  var gameView: GameView? {
    return self.view as? GameView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Games"
    
    fetchGames()
  }
  
  override func loadView() {
    super.loadView()
    
    let view = GameView(frame: self.view.frame)
    view.tableViewDelegate = self
    view.tableViewDataSource = self
    
    self.view = view
  }
  
  func addLoadingViewController() {
    addViewControllerChild(loadingViewController)
  }
  
  func removeLoadingViewController() {
    removeViewControllerChild(loadingViewController)
  }
}

// MARK: - Data Fetching
extension GameViewController {
  func getFetchGamesURLRequest() -> URLRequest {
    if let genreID = genreID {
      return URLRequest.getGamesURL(page: 1, genreID: genreID)
    }
    
    return URLRequest.getGamesURL(page: 1)
  }
  
  func fetchGames() {
    addLoadingViewController()
    
    let urlRequest = getFetchGamesURLRequest()
    let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
      guard let strongSelf = self else { return }
      
      do {
        guard let data = data else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decoded = try decoder.decode(APIResponse<[Game]>.self, from: data)
        
        DispatchQueue.main.async {
          if strongSelf.genreID != nil {
            strongSelf.gamesByGenre = decoded.results
          } else {
            strongSelf.games = decoded.results
          }
          
          strongSelf.gameView?.tableView.reloadData()
          strongSelf.removeLoadingViewController()
        }
      } catch {
        print("fetchGames - ERROR:", error)
      }
    }
    
    task.resume()
  }
}

// MARK: - Table View Delegate & Data Source
extension GameViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isSearchMode {
      return gamesFromSearch.count
    } else if genreID != nil {
      return gamesByGenre.count
    }
    
    return games.count
  }
  
  func getGame(indexPathRow: Int) -> Game {
    if isSearchMode {
      return gamesFromSearch[indexPathRow]
    } else if genreID != nil {
      return gamesByGenre[indexPathRow]
    }
    
    return games[indexPathRow]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = GameTableViewCell.reuseIdentifier
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? GameTableViewCell
    
    let game = getGame(indexPathRow: indexPath.row)
    
    if let backgroundImage = game.backgroundImage {
      let imageURL = URL(string: backgroundImage)
      
      setGameTableViewCellImage(cell: cell, imageURL: imageURL)
    }
    
    setGameTableViewCellLabels(cell: cell, game: game)
    
    return cell ?? UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let game = getGame(indexPathRow: indexPath.row)
    
    let vc = GameDetailsViewController()
    vc.hidesBottomBarWhenPushed = true
    vc.gameID = game.id
    
    if isSearchMode {
      presentingViewController?.navigationController?.pushViewController(vc, animated: true)
    } else {
      navigationController?.pushViewController(vc, animated: true)
    }
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
