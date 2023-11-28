//
//  AddUserViewController.swift
//  UserApp
//
//  Created by Vivek M on 27/11/23.
//

import UIKit

protocol AddUserViewControllerDelegate: AnyObject {
    func viewController(_ vc: AddUserViewController, didAddedUser user: User)
}

class AddUserViewController: UIViewController {
    
    public weak var delegate: AddUserViewControllerDelegate?
    
    private var viewModel = AddUserViewModel()
    private var gender: User.Gender? {
        didSet {
            DispatchQueue.main.async {
                self.tfGender.text = self.gender?.title
            }
        }
    }
    private var loadingIndicator: UIAlertController?
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfGender: UITextField!
    @IBOutlet weak var switchStatus: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        subscribeEvents()
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
    }
}

// MARK:  Actions
extension AddUserViewController {
    //Add user click action
    @IBAction func btnCancelClicked() {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnAddUserClicked() {
        addUser()
    }
    
    //Add gender click action
    @IBAction func btnGenderClicked() {
        let alert = UIAlertController(title: "Choose Gender", message: nil, preferredStyle: .actionSheet)
        User.Gender.allCases.forEach { [weak self] gender in
            alert.addAction(UIAlertAction(title: gender.title, style: .default, handler: { action in
                self?.gender = gender
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func addUser() {
        Task {
            do {
                let user = try await viewModel.addUser(name: tfName.text, email: tfEmail.text, gender: gender, status: switchStatus.isOn)
                showToast(message: "User added successfully")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true) {
                        if let user = user {
                            self.delegate?.viewController(self, didAddedUser: user)
                        }
                    }
                }
            } catch {
                showToast(error: error)
            }
        }
    }
}
