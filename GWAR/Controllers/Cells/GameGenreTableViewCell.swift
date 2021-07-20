//
//  GameGenreTableViewCell.swift
//  GWAR
//
//  Created by Kevin Hermawan on 20/07/21.
//

import UIKit

class GameGenreTableViewCell: UITableViewCell {
  
  static let reuseIdentifier = "GameGenreTableViewCell"
  
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
    
    view.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemOrange
    label.font = UIFont.preferredFont(forTextStyle: .title3)

    return label
  }()
}
