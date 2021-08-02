//
//  FavoriteEmptyViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/08/21.
//

import UIKit

class FavoriteEmptyViewController: UIViewController {
  
  override func loadView() {
    super.loadView()
    
    view = UIView()
    view.backgroundColor = .systemBackground
    
    view.addSubview(titleLabel)
    view.addSubview(descLabel)
    
    setupConstraints()
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.text = "No Favorite Games"
    
    return label
  }()
  
  lazy var descLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.text = "Let's add your favorite games by swipe right in the game list!"
    
    return label
  }()
  
  func setupConstraints() {
    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.leading.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-30)
    }
    
    descLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom)
      make.leading.equalToSuperview().offset(30)
      make.trailing.equalToSuperview().offset(-30)
    }
  }
}
