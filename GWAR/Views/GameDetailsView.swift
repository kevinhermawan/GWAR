//
//  GameDetailsView.swift
//  GWAR
//
//  Created by Kevin Hermawan on 22/07/21.
//

import UIKit

class GameDetailsView: UIView {
  
  weak var tableViewDelegate: UITableViewDelegate? {
    didSet {
      self.tableView.delegate = tableViewDelegate
    }
  }
  
  weak var tableViewDataSource: UITableViewDataSource? {
    didSet {
      self.tableView.dataSource = tableViewDataSource
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
    
  // MARK: - Views
  lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.alwaysBounceVertical = true
    
    view.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var containerView: UIView = {
    let view = UIView()
    
    view.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(230)
    }
    
    view.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(backgroundImageView.snp.bottom).offset(16)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
    }
    
    view.addSubview(descLabel)
    descLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(10)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
    }
    
    view.addSubview(showFullDescriptionButton)
    showFullDescriptionButton.snp.makeConstraints { make in
      make.top.equalTo(descLabel.snp.bottom).offset(10)
      make.leading.equalToSuperview().offset(16)
    }
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(showFullDescriptionButton.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().offset(-50)
      make.height.equalTo(585)
    }
    
    return view
  }()
  
  lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    
    return imageView
  }()
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 32.0, weight: .black)

    return label
  }()
  
  lazy var descLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 4
    label.font = UIFont.systemFont(ofSize: 17.0)

    return label
  }()
  
  lazy var showFullDescriptionButton: UIButton = {
    let button = UIButton()
    button.setUnderlineTitle(title: "Show details")

    return button
  }()
  
  lazy var tableView: UITableView = {
    let view = UITableView(frame: .zero, style: .grouped)
    view.isScrollEnabled = false
    
    let reuseIdentifier = GameDetailsTableViewCell.reuseIdentifier
    view.register(GameDetailsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    
    return view
  }()
}
