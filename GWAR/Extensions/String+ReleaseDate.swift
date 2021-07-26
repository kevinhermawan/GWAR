//
//  String+ReleaseDate.swift
//  GWAR
//
//  Created by Kevin Hermawan on 24/07/21.
//

import Foundation

extension String {
  func formatReleaseDate(tba: Bool) -> String {
    if tba {
      return "TBA"
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date = dateFormatter.date(from: self)
    dateFormatter.dateFormat = "dd MMM yyyy"
    
    let result = dateFormatter.string(from: date ?? Date())
    
    return result
  }
}
