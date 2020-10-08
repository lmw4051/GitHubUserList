//
//  UserDetailViewModel.swift
//  GitHubUserList
//
//  Created by David on 2020/10/8.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class UserDetailViewModel {
  var loginStr: String?
  var downloadImageQueue = OperationQueue()
  var onImageDownloaded: ((UIImage?) -> Void)?
  
  func prepareRequest(completion: @escaping (User) -> Void) {
    guard let loginStr = self.loginStr else { return }
    moyaProvider.request(.user(login: loginStr)) { result in
      switch result {
      case .success(let response):
        let data = try? JSONDecoder().decode(User.self, from: response.data)
        guard let userData = data else { return }
        completion(userData)
        self.getImage(imageUrl: userData.avatar_url)
        break
      case .failure(let error):
        print("Network error: \(error.localizedDescription)")
        break
      }
    }
  }
  
  private func getImage(imageUrl: String?) {
    guard let imageUrl = imageUrl else { return }
    guard let url = URL(string: imageUrl) else { return }
    
    downloadImageQueue.addOperation { [weak self] in
      do {
        let data = try Data(contentsOf: url)
        let image = UIImage(data: data)
        guard let imageDownload = self?.onImageDownloaded else { return }
        imageDownload(image)
      } catch let error {
        print(error.localizedDescription)
      }
    }
  }
}
