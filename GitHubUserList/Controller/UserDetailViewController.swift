//
//  UserDetailViewController.swift
//  GitHubUserList
//
//  Created by David on 2020/10/8.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import SafariServices

class UserDetailViewController: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var headerImageView: UIImageView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var loginNameLabel: UILabel!
  @IBOutlet weak var bioLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var linkLabel: UILabel!
  @IBOutlet weak var siteAdminLabel: UILabel!
  
  let viewModel: UserDetailViewModel = UserDetailViewModel()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureUI()
  }
  
  // MARK: - IBAction Methods
  @IBAction func backButtnPressed(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Helper Methods
  func configureUI() {
    headerImageView.layer.cornerRadius = view.frame.size.width / 4
    
    let linkTap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel))
    linkLabel.isUserInteractionEnabled = true;
    linkLabel.addGestureRecognizer(linkTap)
    
    viewModel.prepareRequest { [weak self] user in
      self?.fullNameLabel.text = user.name
      self?.loginNameLabel.text = user.login
      self?.bioLabel.text = user.bio
      self?.cityLabel.text = user.location
      self?.linkLabel.attributedText = self?.attributedText(text: user.blog ?? "")
      
      guard let siteAdmin = user.site_admin else { return }
      self?.siteAdminLabel.text = siteAdmin ? "ADMIN":"STAFF"
      self?.siteAdminLabel.backgroundColor = siteAdmin ? #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1):#colorLiteral(red: 0.3685780466, green: 0.4235700369, blue: 0.8234271407, alpha: 1)
    }
    
    viewModel.onImageDownloaded = { [weak self] image in
      DispatchQueue.main.async {
        self?.headerImageView.image = image
      }
    }
  }
  
  func attributedText(text: String) -> NSAttributedString {
    let attributedStr = NSAttributedString(string: "\(text)",
      attributes: [.font: UIFont.systemFont(ofSize: 17),
                   .foregroundColor: UIColor.link])
    return attributedStr
  }
  
  // MARK: - Selector Method
  @objc func handleTapOnLabel() {
    if let url = URL(string: linkLabel.attributedText?.string ?? "") {
      let config = SFSafariViewController.Configuration()
      config.entersReaderIfAvailable = true
      
      let vc = SFSafariViewController(url: url, configuration: config)
      present(vc, animated: true)
    }
  }
}
