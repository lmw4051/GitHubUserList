//
//  UserListViewModel.swift
//  GitHubUserList
//
//  Created by David on 2020/10/8.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

class UserListViewModel {
  var listCellVMs: [UserListCellViewModel] = []
  var onRequestEnd: (() -> Void)?
  
  func prepareRequest(page: Int) {
    moyaProvider.request(.users(since: listCellVMs.last?.id ?? 0, perPage: 20, page: page)) { result in
      switch result {
      case .success(let response):
        let data = try? JSONDecoder().decode([User].self, from: response.data)
        guard let userData = data else { return }
        self.convertUserToViewModel(users: userData)
        break
      case .failure(let error):
        print("Network error: \(error.localizedDescription)")
        break
      }
    }
  }
  
  private func convertUserToViewModel(users: [User]) {
    for user in users {
      let listCellVM = UserListCellViewModel()
      listCellVM.avatarUrlStr = user.avatar_url
      listCellVM.loginStr = user.login
      listCellVM.id = user.id
      listCellVM.siteAdmin = user.site_admin
      listCellVMs.append(listCellVM)
    }
    onRequestEnd?()
  }
}
