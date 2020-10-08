//
//  UserDetailViewController.swift
//  GitHubUserList
//
//  Created by David on 2020/10/8.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

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
    viewModel.prepareRequest { [weak self] user in
      self?.fullNameLabel.text = user.name
      self?.loginNameLabel.text = user.login
      self?.bioLabel.text = user.bio
      self?.cityLabel.text = user.location
      self?.linkLabel.text = user.blog ?? ""
      self?.siteAdminLabel.text = user.site_admin! ? "ADMIN":"STAFF"
      self?.siteAdminLabel.backgroundColor = user.site_admin! ? #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1):#colorLiteral(red: 0.3685780466, green: 0.4235700369, blue: 0.8234271407, alpha: 1)
    }
    
    viewModel.onImageDownloaded = { [weak self] image in
      DispatchQueue.main.async {
        self?.headerImageView.image = image
      }
    }
  }
}
