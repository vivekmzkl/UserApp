//
//  AddUserViewModel.swift
//  UserApp
//
//  Created by Vivek M on 27/11/23.
//

import Foundation

class AddUserViewModel: NSObject, LoaderListner {
    
    var loader: Loader?
    
    func subscribe(loader: Loader?) {
        self.loader =  loader
    }
    
    func addUser(name: String?, email: String?, gender: User.Gender?, status: Bool) async throws -> User? {
        guard let name = name, !name.isEmpty else {
            throw ValidationError.required(field: "Name")
        }
        
        guard let email = email, !email.isEmpty else {
            throw ValidationError.required(field: "Email")
        }
        guard ValidaionFactory.isValidEmail(email) else {
            throw ValidationError.badEmail
        }
        
        guard let gender = gender else {
            throw ValidationError.required(field: "Gender")
        }
        let status = status ? User.Status.active : .inactive

        let user = CreateUserParam(name: name, email: email, gender: gender, status: status)

        self.loader?(true)
        let result = await UserRequest.createUser(param: user).result(decodableType: User.self)
        self.loader?(false)
        switch result {
        case .success(let user):
            return user
        case .failure(let error):
            throw error
        }
    }
}
