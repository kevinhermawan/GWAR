//
//  SearchView.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit
import SnapKit

class SearchView: UIView {
  
  weak var tableViewDelegate: UITableViewDelegate? {
    didSet {
      tableView.delegate = self.tableViewDelegate
    }
  }
  
  weak var tableViewDataSource: UITableViewDataSource? {
    didSet {
      tableView.dataSource = self.tableViewDataSource
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  // MARK: - Container View
  lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBackground
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    
    let reuseIdentifier = GameGenreTableViewCell.reuseIdentifier
    tableView.register(GameGenreTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    
    return tableView
  }()
}
