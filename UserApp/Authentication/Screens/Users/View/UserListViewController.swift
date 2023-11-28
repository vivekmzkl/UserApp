//
//  UserListViewController.swift
//  UserApp
//
//  Created by Vivek M on 27/11/23.
//

import UIKit

class UserListViewController: UIViewController {
    
    private var viewModel = UserListViewModel()
    private var loadingIndicator: UIAlertController?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        subscribeEvents() 
        fetchUsers()
    }
    
    func subscribeEvents() {
        viewModel.subscribe { [weak self] loading in
            if self?.loadingIndicator == nil {
                self?.loadingIndicator = self?.loader()
                return
            }
            
            DispatchQueue.main.async {
                self?.loadingIndicator?.dismiss(animated: true) {
                    self?.loadingIndicator = nil
                }
            }
        }
        
        viewModel.subscribe { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.isHidden = self?.viewModel.users.count == 0
            }
            
            if self?.viewModel.users.count == 0 {
                DispatchQueue.main.async {
                    self?.lblError.text = "No data found"
                }
            }
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let navVc = segue.destination as? UINavigationController {
            if let vc = navVc.topViewController as? AddUserViewController {
                vc.delegate = self
            }
        }
    }
    
    func fetchUsers() {
        Task {
            do {
                try await viewModel.fetchUsers()
            } catch {
                showToast(error: error)
                DispatchQueue.main.async {
                    self.tableView.isHidden = self.viewModel.users.count == 0
                    self.lblError.text = error.localizedDescription
                }
            }
        }
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        cell.setUser(viewModel.users[indexPath.row])
        return cell
    }
}

// MARK:  Actions
extension UserListViewController {
    //Add uer click action
    @IBAction func btnAddUserClicked() {
        //Performing Segue to present Add User page
        performSegue(withIdentifier: "segue.userlist.adduser", sender: self)
    }
}

extension UserListViewController: AddUserViewControllerDelegate {
    func viewController(_ vc: AddUserViewController, didAddedUser user: User) {
        viewModel.newUserAdded(user: user)
    }
}
