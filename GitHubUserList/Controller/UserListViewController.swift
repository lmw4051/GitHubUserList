//
//  UserListViewController.swift
//  GitHubUserList
//
//  Created by David on 2020/10/8.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import Moya

private let reuseIdentifier = "UserListCell"

class UserListViewController: UIViewController {
  // MARK: - Properties
  let viewModel: UserListViewModel = UserListViewModel()
  var page: Int = 1
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()        
    viewModel.prepareRequest(page: page)
    bindViewModel()
  }
  
  // MARK: - Help Methods
  func bindViewModel() {
    viewModel.onRequestEnd = { [weak self] in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
        
        if let indexPaths = self?.tableView.indexPathsForVisibleRows {
          self?.tableView.reloadRows(at: indexPaths, with: .automatic)
        } else {
          self?.tableView.reloadData()
        }
      }
    }
  }
}

// MARK: - UITableViewDataSource Methods
extension UserListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.listCellVMs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserListCell
    let listCellViewModel = viewModel.listCellVMs[indexPath.row]
    cell.setup(viewModel: listCellViewModel)
    return cell
  }
}

// MARK: - UITableViewDelegate Methods
extension UserListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.listCellVMs.count - 10 {
      if viewModel.listCellVMs.count < 100 {
        page += 1
        viewModel.prepareRequest(page: page)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
    let listCellVM = viewModel.listCellVMs[indexPath.row]
    guard let login = listCellVM.loginStr else { return }
    
    let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UserDetailVC") as! UserDetailViewController
    detailVC.viewModel.loginStr = login
    self.present(detailVC, animated: true, completion: nil)
  }
}
