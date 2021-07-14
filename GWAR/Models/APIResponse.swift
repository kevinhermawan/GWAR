//
//  APIResponse.swift
//  GWAR
//
//  Created by Kevin Hermawan on 14/07/21.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
  let count: Int
  let next: String?
  let previous: String?
  let results: T
}
