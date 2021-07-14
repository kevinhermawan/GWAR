//
//  GameRating.swift
//  GWAR
//
//  Created by Kevin Hermawan on 14/07/21.
//

import Foundation

struct GameRating: Codable {
  let id: Int
  let title: String
  let count: Int
  let percent: Double
}
