//
//  GameTableViewCell.swift
//  GWAR
//
//  Created by Kevin Hermawan on 14/07/21.
//

import UIKit

class GameTableViewCell: UITableViewCell {
  
  static let reuseIdentifier = "GameTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  // MARK: - Views
  lazy var containerView: UIView = {
    let view = UIView()
    
    view.addSubview(containerLeftView)
    containerLeftView.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview()
      make.width.equalTo(150.0)
    }
    
    view.addSubview(containerRightView)
    containerRightView.snp.makeConstraints { make in
      make.top.trailing.bottom.equalToSuperview()
      make.leading.equalTo(containerLeftView.snp.trailing)
    }
    
    return view
  }()
  
  lazy var containerLeftView: UIView = {
    let view = UIView()
    
    view.addSubview(gameImageView)
    gameImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 8))
    }
    
    return view
  }()
  
  lazy var gameImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.setRounded(radius: 8.0)
    
    return imageView
  }()
  
  lazy var containerRightView: UIView = {
    let view = UIView()
    
    view.addSubview(gameGenreLabel)
    gameGenreLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.leading.equalToSuperview().offset(8)
      make.trailing.equalToSuperview().offset(-16)
    }
    
    view.addSubview(gameNameLabel)
    gameNameLabel.snp.makeConstraints { make in
      make.top.equalTo(gameGenreLabel.snp.bottom).offset(4)
      make.leading.equalToSuperview().offset(8)
      make.trailing.equalToSuperview().offset(-16)
    }
    
    return view
  }()
  
  lazy var gameGenreLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = UIFont.systemFont(ofSize: 15.0)
    
    return label
  }()
  
  lazy var gameNameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = UIFont.boldSystemFont(ofSize: 20.0)
    
    return label
  }()
}
