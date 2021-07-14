//
//  GamePlatform.swift
//  GWAR
//
//  Created by Kevin Hermawan on 14/07/21.
//

import Foundation

struct GamePlatform: Codable {
  struct Platform: Codable {
    let id: Int
    let slug: String
    let name: String
  }
  
  struct Requirement: Codable {
    let minimum: String?
    let recommended: String?
  }
  
  let platform: Platform?
  let requirementsEn: Requirement?
}
