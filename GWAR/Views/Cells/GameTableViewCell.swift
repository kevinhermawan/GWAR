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
      make.top.bottom.equalToSuperview().inset(10)
      make.leading.trailing.equalToSuperview().inset(20)
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
      make.width.equalTo(130.0)
      make.top.leading.bottom.equalToSuperview()
    }
    
    view.addSubview(containerRightView)
    containerRightView.snp.makeConstraints { make in
      make.leading.equalTo(containerLeftView.snp.trailing).offset(10)
      make.top.trailing.bottom.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var containerLeftView: UIView = {
    let view = UIView()
    
    view.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.setRounded(radius: 5.0)
    
    return imageView
  }()
  
  lazy var containerRightView: UIView = {
    let view = UIView()
    
    view.addSubview(genreLabel)
    genreLabel.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
    
    view.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(genreLabel.snp.bottom).offset(4)
      make.leading.trailing.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var genreLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = UIFont.systemFont(ofSize: 15.0)
    
    return label
  }()
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = UIFont.boldSystemFont(ofSize: 20.0)
    
    return label
  }()
}
