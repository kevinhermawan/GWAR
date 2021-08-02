//
//  URLRequest+RAWG.swift
//  GWAR
//
//  Created by Kevin Hermawan on 14/07/21.
//

import Foundation

extension URLRequest {
  private static func apiKeyQueryItem() -> URLQueryItem {
    guard let filePath = Bundle.main.path(forResource: "RAWG-Info", ofType: "plist") else {
      fatalError("Couldn't find file 'RAWG-Info.plist'.")
    }
    
    let plist = NSDictionary(contentsOfFile: filePath)
    
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Couldn't find key 'API_KEY' in 'RAWG-Info.plist'.")
    }
    
    return URLQueryItem(name: "key", value: value)
  }
  
  static func getGamesURL(page: Int) -> URLRequest {
    var components = URLComponents(string: "https://api.rawg.io/api/games")!
    components.queryItems = [
      URLQueryItem(name: "page", value: "\(page)"),
      apiKeyQueryItem()
    ]
    
    let request = URLRequest(url: components.url!)
    
    return request
  }
  
  static func getGamesURL(page: Int, search: String) -> URLRequest {
    var components = URLComponents(string: "https://api.rawg.io/api/games")!
    components.queryItems = [
      URLQueryItem(name: "page", value: "\(page)"),
      URLQueryItem(name: "search", value: search),
      apiKeyQueryItem()
    ]
    
    let request = URLRequest(url: components.url!)
    
    return request
  }
  
  static func getGamesURL(page: Int, genreID: Int) -> URLRequest {
    var components = URLComponents(string: "https://api.rawg.io/api/games")!
    components.queryItems = [
      URLQueryItem(name: "page", value: "\(page)"),
      URLQueryItem(name: "genres", value: "\(genreID)"),
      apiKeyQueryItem()
    ]
    
    let request = URLRequest(url: components.url!)
    
    return request
  }
  
  static func getGameDetailsURL(id: Int) -> URLRequest {
    var components = URLComponents(string: "https://api.rawg.io/api/games/\(id)")!
    components.queryItems = [apiKeyQueryItem()]
    
    let request = URLRequest(url: components.url!)
    
    return request
  }
  
  static func getGenresURL() -> URLRequest {
    var components = URLComponents(string: "https://api.rawg.io/api/genres")!
    components.queryItems = [apiKeyQueryItem()]
    
    let request = URLRequest(url: components.url!)
    
    return request
  }
}
