//
//  AboutView.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit
import SnapKit

class AboutView: UIView {
  
  weak var aboutTableViewDelegate: UITableViewDelegate? {
    didSet {
      self.aboutTableView.delegate = aboutTableViewDelegate
    }
  }
  
  weak var aboutTableViewDataSource: UITableViewDataSource? {
    didSet {
      self.aboutTableView.dataSource = aboutTableViewDataSource
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
  
  lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBackground
    
    view.addSubview(aboutTableView)
    aboutTableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    return view
  }()
  
  lazy var aboutTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.allowsSelection = false
    
    let reuseIdentifier = ProfileTableViewCell.reuseIdentifier
    tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    
    return tableView
  }()
}
