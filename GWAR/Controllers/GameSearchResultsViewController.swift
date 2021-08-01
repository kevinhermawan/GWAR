//
//  GameSearchResultsViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 01/08/21.
//

import UIKit

class GameSearchResultsViewController: UIViewController {
  
  private let loadingViewController = LoadingViewController()
  
  private var games = [Game]()
  
  var gameView: GameView? {
    return self.view as? GameView
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
extension GameSearchResultsViewController {
  func fetchGames(searchValue: String) {
    addViewControllerChild(loadingViewController)
    
    let urlRequest = URLRequest.getGamesURL(page: 1, search: searchValue)
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
extension GameSearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let vc = GameDetailsViewController()
    vc.hidesBottomBarWhenPushed = true
    
    let game = games[indexPath.row]
    vc.gameID = game.id
    
    presentingViewController?.navigationController?.pushViewController(vc, animated: true)
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
