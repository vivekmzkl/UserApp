//
//  UserListViewModel.swift
//  UserApp
//
//  Created by Vivek M on 28/11/23.
//

import Foundation

class UserListViewModel: NSObject, LoaderListner {
    var users: [User] = [] {
        didSet {
            dataSourceChange?()
        }
    }
    var loader: Loader?
    
    func subscribe(loader: Loader?) {
        self.loader = loader
    }
    var dataSourceChange: (() -> Void)?
    
    func subscribe(dataSourceChange changeListner: @escaping () -> Void) {
        self.dataSourceChange = changeListner
    }
    
    func newUserAdded(user: User) {
        users.insert(user, at: 0)
    }
    
    func fetchUsers() async throws {
        self.loader?(true)
        let result = await UserRequest.users.result(decodableType: [User].self)
        self.loader?(false)
        switch result {
        case .success(let users):
            self.users = users
        case .failure(let error):
            throw error
        }
    }
}
