//
//  ProfileTableViewCell.swift
//  GWAR
//
//  Created by Kevin Hermawan on 15/07/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
  
  static let reuseIdentifier = "ProfileTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
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
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(20)
      make.bottom.equalToSuperview().offset(-10)
      make.centerY.equalToSuperview()
      make.width.equalTo(50)
    }
    
    view.addSubview(containerRightView)
    containerRightView.snp.makeConstraints { make in
      make.leading.equalTo(containerLeftView.snp.trailing).offset(10)
      make.centerY.trailing.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var containerLeftView: UIView = {
    let view = UIView()
    
    view.addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.setRounded(radius: 5)
    
    return imageView
  }()
  
  lazy var containerRightView: UIView = {
    let view = UIView()
    
    view.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
    }
    
    view.addSubview(bioLabel)
    bioLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    return label
  }()
  
  lazy var bioLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = UIFont.systemFont(ofSize: 15)
    
    return label
  }()
}
