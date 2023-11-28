//
//  UserRequest.swift
//  UserApp
//
//  Created by Vivek M on 28/11/23.
//

import Foundation

enum UserRequest {
    case users
    case createUser(param: CreateUserParam)
}

extension UserRequest: APIRequest {
    var method: HTTPMethod {
        switch self {
        case .users:
                .get
        case .createUser:
                .post
        }
    }
    
    var endpoint: String {
        "users"
    }
    
    var encodable: Encodable? {
        switch self {
        case .users:
            nil
        case .createUser(let param):
            param
        }
    }
}
