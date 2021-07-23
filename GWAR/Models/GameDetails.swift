//
//  GameDetails.swift
//  GWAR
//
//  Created by Kevin Hermawan on 22/07/21.
//

import Foundation

struct GameDetails: Codable {
  let id: Int
  let name: String
  let descriptionRaw: String
  let website: String
  let backgroundImage: String?
  let tba: Bool
  let released: String
  let rating: Double
  let ratings: [GameRating]?
  let genres: [GameGenre]?
  let platforms: [GamePlatform]?
  let developers: [GameDeveloper]?
  let publishers: [GamePublisher]?
}
