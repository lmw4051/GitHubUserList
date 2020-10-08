//
//  UserListCell.swift
//  GitHubUserList
//
//  Created by David on 2020/10/8.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var loginNameLabel: UILabel!
  @IBOutlet weak var siteAdminLabel: UILabel!
  
  private var viewModel: UserListCellViewModel?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 2.0
    self.avatarImageView.layer.cornerRadius = 30.0
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.avatarImageView.image = nil
    self.viewModel?.onImageDownloaded = nil
  }
  
  func setup(viewModel: UserListCellViewModel) {
    self.viewModel = viewModel
    self.loginNameLabel.text = viewModel.loginStr
    self.siteAdminLabel.text = viewModel.siteAdmin! ? "ADMIN":"STAFF"
    self.siteAdminLabel.backgroundColor = viewModel.siteAdmin! ? #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1):#colorLiteral(red: 0.3685780466, green: 0.4235700369, blue: 0.8234271407, alpha: 1)
    
    self.viewModel?.onImageDownloaded = { [weak self] image in
      DispatchQueue.main.async {
        self?.avatarImageView.image = image
      }
    }
    self.viewModel?.getImage()
  }
}
