//
//  AboutViewController.swift
//  GWAR
//
//  Created by Kevin Hermawan on 02/07/21.
//

import UIKit
import Kingfisher

class AboutViewController: UIViewController {
  
  private let loadingViewController = LoadingViewController()
  
  private var aboutView: AboutView? {
    return self.view as? AboutView
  }
  
  private var profile: Profile?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchProfile()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    tabBarController?.title = "About"
    tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func loadView() {
    super.loadView()
    
    let view = AboutView(frame: self.view.frame)
    view.aboutTableViewDelegate = self
    view.aboutTableViewDataSource = self
    
    self.view = view
  }
}

// MARK: - Data Fetching
extension AboutViewController {
  func fetchProfile() {
    addViewControllerChild(loadingViewController)
    
    let baseURL = "https://gist.githubusercontent.com/kevinstd"
    let url = URL(string: "\(baseURL)/fe600dd327e87d1ce4c68c04b2b61eed/raw/profile.json")!
    
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
      guard let strongSelf = self else {
        return
      }
      
      do {
        guard let data = data else {
          return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decoded = try decoder.decode(Profile.self, from: data)
        
        DispatchQueue.main.async {
          strongSelf.profile = decoded
          strongSelf.aboutView?.aboutTableView.reloadData()
          strongSelf.removeViewControllerChild(strongSelf.loadingViewController)
        }
      } catch {
        print("fetchProfile - ERROR:", error)
      }
    }
    
    task.resume()
  }
}

// MARK: - Table View Delegate & Data Source
extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 2:
      return profile?.socials.count ?? 0
    default:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let profileIdentifier = ProfileTableViewCell.reuseIdentifier
    let profileCell = tableView.dequeueReusableCell(withIdentifier: profileIdentifier, for: indexPath) as! ProfileTableViewCell

    let aboutCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    aboutCell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

    switch indexPath.section {
    case 0:
      return setProfileSectionCell(for: profileCell, indexPath: indexPath)
    case 1:
      return setDetailsSectionCell(for: aboutCell, indexPath: indexPath)
    case 2:
      return setSocialSectionCell(for: aboutCell, indexPath: indexPath)
    default:
      return UITableViewCell()
    }
  }
  
  func setProfileSectionCell(for cell: ProfileTableViewCell, indexPath: IndexPath) -> UITableViewCell {
    if let photoURLString = profile?.photo {
      let photoURL = URL(string: photoURLString)
      
      cell.profileImageView.kf.setImage(with: photoURL)
    }
    
    cell.nameLabel.text = profile?.name
    cell.bioLabel.text = profile?.bio
    
    return cell
  }
  
  func setDetailsSectionCell(for cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
    cell.textLabel?.text = profile?.details
    cell.textLabel?.numberOfLines = 0
    
    return cell
  }
  
  func setSocialSectionCell(for cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
    let social = profile?.socials[indexPath.row]
        
    cell.textLabel?.text = social?.name
    cell.detailTextLabel?.text = social?.url
    cell.detailTextLabel?.textColor = .secondaryLabel
    
    return cell
  }
}
