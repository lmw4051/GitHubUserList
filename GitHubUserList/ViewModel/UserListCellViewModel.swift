//
//  UserListCellViewModel.swift
//  GitHubUserList
//
//  Created by David on 2020/10/8.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class UserListCellViewModel {
  var avatarUrlStr: String?
  var loginStr: String?
  var cellIdentifier: String!
  var id: Int?
  var siteAdmin: Bool?
  
  var onImageDownloaded: ((UIImage?) -> Void)?
  private let downloadImageQueue = OperationQueue()
  
  func getImage() {
    guard let imageUrl = avatarUrlStr else { return }
    guard let url = URL(string: imageUrl) else { return }
    
    downloadImageQueue.addOperation { [weak self] in
      do {
        let data = try Data(contentsOf: url)
        let image = UIImage(data: data)
        guard let imageDownloaded = self?.onImageDownloaded else { return }
        imageDownloaded(image)
      } catch let error {
        print(error.localizedDescription)
      }
    }
  }
}
