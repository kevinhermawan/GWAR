//
//  Game.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import Foundation

struct Game: Codable {
  let id: Int
  let name: String
  let backgroundImage: String?
  let genres: [GameGenre]?
}
