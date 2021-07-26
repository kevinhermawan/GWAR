//
//  GameFullDescriptionViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 23/07/21.
//

import UIKit
import SnapKit

class GameFullDescriptionViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Description"
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissVC))
    
    view.backgroundColor = .systemBackground
    
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    scrollView.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
    
    containerView.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      let edgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 50, right: 20)
      make.edges.equalToSuperview().inset(edgeInsets)
    }
  }
  
  @objc func dismissVC() {
    navigationController?.dismiss(animated: true)
  }
  
  lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    
    return view
  }()
  
  lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBackground
    
    return view
  }()
  
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    
    return label
  }()
}
