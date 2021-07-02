//
//  GameView.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit
import SnapKit

class GameView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(containerView)
    
    setupContainerConstraints()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func setupContainerConstraints() {
    containerViewConstraint()
  }
  
  // MARK: - Container View
  lazy var containerView: UIView = {
    let view = UIView()
    
    return view
  }()
  
  func containerViewConstraint() {    
    containerView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
  }
}
