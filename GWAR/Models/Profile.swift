//
//  Profile.swift
//  GWAR
//
//  Created by Kevin Hermawan on 15/07/21.
//

import Foundation

struct Profile: Codable {
  let name: String
  let bio: String
  let photo: String
  let details: String
  let socials: [ProfileSocial]
}
