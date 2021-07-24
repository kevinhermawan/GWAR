//
//  String+RatingEmoticon.swift
//  GWAR
//
//  Created by Kevin Hermawan on 24/07/21.
//

import Foundation

extension String {
  func withRatingEmoticon(rating: String?) -> String {
    switch rating {
    case "exceptional":
      return self.appending(" 🎯")
    case "recommended":
      return self.appending(" 👍")
    case "meh":
      return self.appending(" 😐")
    case "skip":
      return self.appending(" ⛔")
    default:
      return self
    }
  }
}
