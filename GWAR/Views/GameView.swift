//
//  GameView.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit
import SnapKit

class GameView: UIView {
  
  weak var gameTableViewDelegate: UITableViewDelegate? {
    didSet {
      self.gameTableView.delegate = gameTableViewDelegate
    }
  }
  
  weak var gameTableViewDataSource: UITableViewDataSource? {
    didSet {
      self.gameTableView.dataSource = gameTableViewDataSource
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(containerView)
    
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func setupConstraints() {
    containerViewConstraint()
    gameTableViewConstraint()
  }
  
  // MARK: - Container View
  lazy var containerView: UIView = {
    let view = UIView()
    
    view.addSubview(gameTableView)
    
    return view
  }()
  
  func containerViewConstraint() {
    containerView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Game Table View
  lazy var gameTableView: UITableView = {
    let tableView = UITableView()
    
    tableView.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.reuseIdentifier)
    
    return tableView
  }()
  
  func gameTableViewConstraint() {
    gameTableView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
  }
}
