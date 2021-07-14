//
//  LoadingViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 04/07/21.
//

import UIKit

class LoadingViewController: UIViewController {
  
  override func loadView() {
    super.loadView()
    
    view = UIView()
    view.backgroundColor = .systemBackground

    view.addSubview(activityIndicatorView)
    
    setupConstraints()
  }
  
  lazy var activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    activityIndicatorView.startAnimating()
    
    return activityIndicatorView
  }()
  
  func setupConstraints() {
    activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
