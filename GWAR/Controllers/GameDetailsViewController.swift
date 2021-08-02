//
//  GameDetailsViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 22/07/21.
//

import UIKit
import Kingfisher

class GameDetailsViewController: UIViewController {
  
  private let favoriteGameCoreData = FavoriteGameCoreData()
  private let loadingVC = LoadingViewController()
  
  private var isFavorited = false
  
  var gameID: Int?
  var gameDetails: GameDetails?
  
  var tableViewData = [TableViewSection]()
  
  var gameDetailsView: GameDetailsView? {
    return self.view as? GameDetailsView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
    
    checkIsFavorited()
    fetchGameDetails()
  }
  
  override func loadView() {
    super.loadView()
    
    let view = GameDetailsView(frame: self.view.frame)
    view.tableViewDelegate = self
    view.tableViewDataSource = self
    view.showFullDescriptionButton.addTarget(self, action: #selector(handleShowFullDescription), for: .touchUpInside)
    
    self.view = view
  }
  
  @objc func handleShowFullDescription() {
    let rootVC = GameFullDescriptionViewController()
    rootVC.descriptionLabel.text = gameDetails?.descriptionRaw
    
    let vc = UINavigationController(rootViewController: rootVC)
    
    navigationController?.present(vc, animated: true)
  }
  
  @objc func handleFavorite() {
    if isFavorited {
      deleteGameFromFavorite()
    } else {
      saveGameToFavorite()
    }
  }
  
  func setupFavoriteBarButtonItem(favorite: Bool) {
    let favoriteIcon = UIImage(systemName: favorite ? "heart.fill" : "heart")
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: favoriteIcon,
      style: .plain,
      target: self,
      action: #selector(handleFavorite)
    )
  }
}

// MARK: - Data Fetching
extension GameDetailsViewController {
  func fetchGameDetails() {
    addViewControllerChild(loadingVC)
    
    guard let gameID = gameID else { return }
    
    let request = URLRequest.getGameDetailsURL(id: gameID)
    let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
      guard let strongSelf = self else { return }
      
      do {
        guard let data = data else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decoded = try decoder.decode(GameDetails.self, from: data)
        
        DispatchQueue.main.async {
          strongSelf.gameDetails = decoded
          strongSelf.setDataToView(gameDetails: decoded)
          strongSelf.removeViewControllerChild(strongSelf.loadingVC)
        }
      } catch {
        print("fetchGameDetails - ERROR:", error)
      }
    }
    
    task.resume()
  }
  
  func setDataToView(gameDetails: GameDetails) {
    if let imageURLString = gameDetails.backgroundImage {
      let imageURL = URL(string: imageURLString)
      
      gameDetailsView?.backgroundImageView.kf.setImage(with: imageURL)
    }
    
    let firstRating = gameDetails.ratings?.first?.title
    gameDetailsView?.genreLabel.text = gameDetails.genres?.map({ $0.name }).joined(separator: ", ")
    gameDetailsView?.nameLabel.text = gameDetails.name.withRatingEmoticon(rating: firstRating)
    gameDetailsView?.descLabel.text = gameDetails.descriptionRaw
    
    setTableViewSection1(gameDetails: gameDetails)
    setTableViewSection2(gameDetails: gameDetails)
    
    gameDetailsView?.tableView.reloadData()
  }
  
  func setTableViewSection1(gameDetails: GameDetails) {
    let ratings = gameDetails.ratings?.map({ TableViewSection.Data(title: $0.title.capitalized, detail: "\($0.count)".withRatingEmoticon(rating: $0.title)) })
    
    var section = TableViewSection()
    section.title = "Ratings"
    section.data = ratings
    
    tableViewData.append(section)
  }
  
  func setTableViewSection2(gameDetails: GameDetails) {
    let releaseDate = gameDetails.released.formatReleaseDate(tba: gameDetails.tba)
    let developer = gameDetails.developers?.map({ $0.name }).joined(separator: ", ")
    let publisher = gameDetails.publishers?.map({ $0.name }).joined(separator: ", ")
    let website = gameDetails.website
    
    var section = TableViewSection()
    section.title = "Info"
    section.data = [
      TableViewSection.Data(title: "Release Date", detail: releaseDate),
      TableViewSection.Data(title: "Developer", detail: developer),
      TableViewSection.Data(title: "Publisher", detail: publisher),
      TableViewSection.Data(title: "Website", detail: website)
    ]
    
    tableViewData.append(section)
  }
}

// MARK: - Table View Delegate & Data Source
extension GameDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return tableViewData.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return tableViewData[section].title
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewData[section].data?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = GameDetailsTableViewCell.reuseIdentifier
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? GameDetailsTableViewCell
    
    let data = tableViewData[indexPath.section].data?[indexPath.row]
    
    cell?.textLabel?.text = data?.title
    cell?.detailTextLabel?.text = data?.detail
    
    return cell ?? UITableViewCell()
  }
}

// MARK: - Core Data
extension GameDetailsViewController {
  func checkIsFavorited() {
    guard let id = gameID else { return }
    
    let gameForCoreData = favoriteGameCoreData.retrieveById(id: id)
    let favorited = gameForCoreData.id != nil
    
    isFavorited = favorited
    setupFavoriteBarButtonItem(favorite: favorited)
  }
  
  func saveGameToFavorite() {
    let game = Game(
      id: gameDetails?.id ?? 0,
      name: gameDetails?.name ?? "",
      backgroundImage: gameDetails?.backgroundImage,
      tba: gameDetails?.tba ?? false,
      released: gameDetails?.released,
      genres: gameDetails?.genres,
      rating: gameDetails?.rating,
      ratings: gameDetails?.ratings
    )
    
    favoriteGameCoreData.save(game: game)
    
    isFavorited = true
    setupFavoriteBarButtonItem(favorite: true)
  }
  
  func deleteGameFromFavorite() {
    guard let id = gameID else { return }
    
    favoriteGameCoreData.delete(id: Int32(id))
    
    isFavorited = false
    setupFavoriteBarButtonItem(favorite: false)
  }
}
