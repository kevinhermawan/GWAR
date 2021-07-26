//
//  GameView.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit
import SnapKit

class GameView: UIView {
  
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
    view.backgroundColor = .systemBackground
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = 140
    
    let reuseIdentifier = GameTableViewCell.reuseIdentifier
    tableView.register(GameTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    
    return tableView
  }()
}
