//
//  URLRequest+RAWG.swift
//  GWAR
//
//  Created by Kevin Hermawan on 14/07/21.
//

import Foundation

extension URLRequest {
  static func getGamesURL(page: Int, search: String?) -> URLRequest {
    var components = URLComponents(string: "https://api.rawg.io/api/games")!
    
    components.queryItems = [
      URLQueryItem(name: "page", value: "\(page)"),
      URLQueryItem(name: "search", value: search ?? ""),
      URLQueryItem(name: "key", value: "")
    ]
    
    let request = URLRequest(url: components.url!)
    
    return request
  }
  
  static func getGenresURL() -> URLRequest {
    var components = URLComponents(string: "https://api.rawg.io/api/genres")!
    
    components.queryItems = [
      URLQueryItem(name: "key", value: "")
    ]
    
    let request = URLRequest(url: components.url!)
    
    return request
  }
}
