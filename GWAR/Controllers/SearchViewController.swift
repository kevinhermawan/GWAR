//
//  SearchViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit

class SearchViewController: UIViewController {
  
  private let loadingViewController = LoadingViewController()
  private let searchController = UISearchController(searchResultsController: GameViewController())
  
  private var searchView: SearchView? {
    return self.view as? SearchView
  }
  
  private var genres = [GameGenre]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchGenres()
  }
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    tabBarController?.title = "Search"
    tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
    
    searchController.searchBar.delegate = self
    searchController.searchBar.placeholder = "Search games"
    
    let searchResultsVC = searchController.searchResultsController as! GameViewController
    searchResultsVC.isSearchMode = true
    
    tabBarController?.navigationItem.hidesSearchBarWhenScrolling = false
    tabBarController?.navigationItem.searchController = searchController
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    
    tabBarController?.navigationItem.searchController = nil
  }
  
  override func loadView() {
    super.loadView()
    
    let view = SearchView(frame: self.view.frame)
    view.tableViewDelegate = self
    view.tableViewDataSource = self
    
    self.view = view
  }
}

// MARK: - Navigation
extension SearchViewController {
  func navigateToGameByGenre(genre: GameGenre) {
    let vc = GameViewController()
    vc.title = genre.name
    vc.genreID = genre.id
    
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - Data Fetching
extension SearchViewController {
  func fetchGenres() {
    addViewControllerChild(loadingViewController)
    
    let task = URLSession.shared.dataTask(with: URLRequest.getGenresURL()) { [weak self] data, _, error in
      guard let strongSelf = self else { return }
      
      do {
        guard let data = data else { return}
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decoded = try decoder.decode(APIResponse<[GameGenre]>.self, from: data)
        
        DispatchQueue.main.async {
          strongSelf.genres = decoded.results
          strongSelf.searchView?.tableView.reloadData()
          strongSelf.removeViewControllerChild(strongSelf.loadingViewController)
        }
      } catch {
        print("fetchGenres - ERROR:", error)
      }
    }
    
    task.resume()
  }
  
  func fetchSearch(searchValue: String) {
    let searchResultsVC = self.searchController.searchResultsController as? GameViewController
    searchResultsVC?.addLoadingViewController()
    
    let urlRequest = URLRequest.getGamesURL(page: 1, search: searchValue)
    
    let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
      guard let strongSelf = self else { return }
      
      do {
        guard let data = data else { return}
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decoded = try decoder.decode(APIResponse<[Game]>.self, from: data)
        
        DispatchQueue.main.async {
          let searchResultsVC = strongSelf.searchController.searchResultsController as? GameViewController
          searchResultsVC?.gamesFromSearch = decoded.results
          searchResultsVC?.gameView?.tableView.reloadData()
          searchResultsVC?.removeLoadingViewController()
        }
      } catch {
        print("fetchSearch - ERROR:", error)
      }
    }
    
    task.resume()
  }
}

// MARK: - Table View Delegate & Data Source
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Discover"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return genres.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = GameGenreTableViewCell.reuseIdentifier
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! GameGenreTableViewCell
    
    let genre = genres[indexPath.row]
    cell.nameLabel.text = genre.name
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let genre = genres[indexPath.row]
    
    navigateToGameByGenre(genre: genre)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    if let searchValue = searchBar.text {
      fetchSearch(searchValue: searchValue)
    }
  }
}
