//
//  ErrorViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 04/07/21.
//

import UIKit

class ErrorViewController: UIViewController {
  
  override func loadView() {
    super.loadView()
        
    view.addSubview(titleLabel)
    view.addSubview(descLabel)
    
    setupConstraints()
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    
    return label
  }()
  
  lazy var descLabel: UILabel = {
    let label = UILabel()
    
    return label
  }()
}

// MARK: - General
extension ErrorViewController {
  func setupConstraints() {
    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    descLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom)
    }
  }
}
