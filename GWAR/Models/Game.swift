//
//  Game.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import Foundation

struct Game: Codable {
  let id: Int
  let slug: String
  let name: String
  let released: String
  let backgroundImage: String?
  let rating: Double
  let ratings: [GameRating]
  let platforms: [GamePlatform]
  let genres: [GameGenre]
}
