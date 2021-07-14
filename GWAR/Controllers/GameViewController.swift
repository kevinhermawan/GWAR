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
  
  private var gameView: GameView? {
    return self.view as? GameView
  }
  
  private var games = [Game]()
  
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
    view.gameTableViewDelegate = self
    view.gameTableViewDataSource = self
    
    self.view = view
  }
}

// MARK: - Data Fetching
extension GameViewController {
  func fetchGames() {
    addViewControllerChild(loadingViewController)
    
    let task = URLSession.shared.dataTask(with: URLRequest.getGamesURL(page: 1)) { [weak self] data, _, error in
      guard let strongSelf = self else {
        return
      }
      
      do {
        guard let data = data else {
          return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decoded = try decoder.decode(APIResponse<[Game]>.self, from: data)
        
        DispatchQueue.main.async {
          strongSelf.games = decoded.results
          strongSelf.gameView?.gameTableView.reloadData()
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
extension GameViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120.0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return games.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = GameTableViewCell.reuseIdentifier
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! GameTableViewCell
    
    let game = games[indexPath.row]
    
    if let backgroundImage = game.backgroundImage {
      let imageURL = URL(string: backgroundImage)
      
      setGameTableViewCellImage(cell: cell, imageURL: imageURL)
    }
    
    setGameTableViewCellLabels(cell: cell, game: game)
    
    return cell
  }
  
  func setGameTableViewCellImage(cell: GameTableViewCell, imageURL: URL?) {
    cell.gameImageView.kf.indicatorType = .activity
    cell.gameImageView.kf.setImage(with: imageURL)
  }
  
  func setGameTableViewCellLabels(cell: GameTableViewCell, game: Game) {
    let genre = game.genres.map({ $0.name }).joined(separator: ", ")
    
    cell.gameGenreLabel.text = genre
    cell.gameNameLabel.text = game.name    
  }
}
