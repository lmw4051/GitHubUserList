//
//  User.swift
//  GitHubUserList
//
//  Created by David on 2020/10/8.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

struct User: Decodable {
  var avatar_url: String?
  var site_admin: Bool?
  var login: String?
  var id: Int?
  var name: String?
  var bio: String?
  var location: String?
  var blog: String?
  var type: String?
}
