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
    
    view.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
  }
  
  @objc func dismissVC() {
    navigationController?.dismiss(animated: true)
  }
  
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center

    return label
  }()
}
