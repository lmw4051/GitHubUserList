//
//  UserListViewController.swift
//  GitHubUserList
//
//  Created by David on 2020/10/8.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import Moya
import MBProgressHUD

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
    MBProgressHUD.showAdded(to: view, animated: true)
    viewModel.onRequestEnd = { [weak self] in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.tableView.reloadData()
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
        
    if indexPath.row == viewModel.listCellVMs.count - 1 {
      if viewModel.listCellVMs.count < 100 {
        page += 1
        viewModel.prepareRequest(page: page)
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
      } else {
        tableView.tableFooterView = nil
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
