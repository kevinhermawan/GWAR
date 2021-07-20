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
  
  var gameView: GameView? {
    return self.view as? GameView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchGames()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    tabBarController?.title = "Games"
    tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
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
  func fetchGames() {
    addLoadingViewController()
    
    let urlRequest = URLRequest.getGamesURL(page: 1, search: nil)
    
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
    }
    
    return games.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = GameTableViewCell.reuseIdentifier
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! GameTableViewCell
    
    let game = isSearchMode ? gamesFromSearch[indexPath.row] : games[indexPath.row]
    
    if let backgroundImage = game.backgroundImage {
      let imageURL = URL(string: backgroundImage)
      
      setGameTableViewCellImage(cell: cell, imageURL: imageURL)
    }
    
    setGameTableViewCellLabels(cell: cell, game: game)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func setGameTableViewCellImage(cell: GameTableViewCell, imageURL: URL?) {
    cell.backgroundImageView.kf.indicatorType = .activity
    cell.backgroundImageView.kf.setImage(with: imageURL)
  }
  
  func setGameTableViewCellLabels(cell: GameTableViewCell, game: Game) {
    let genre = game.genres?.map({ $0.name }).joined(separator: ", ")
    
    cell.genreLabel.text = genre
    cell.nameLabel.text = game.name
  }
}
