//
//  URLRequest+RAWG.swift
//  GWAR
//
//  Created by Kevin Hermawan on 14/07/21.
//

import Foundation

extension URLRequest {
  private static func apiKeyQueryItem() -> URLQueryItem {
    return URLQueryItem(name: "key", value: "")
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
