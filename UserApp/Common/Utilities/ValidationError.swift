//
//  ValidationError.swift
//  UserApp
//
//  Created by Vivek M on 28/11/23.
//

import Foundation

enum ValidationError: Error {
    case required(field: String)
    case badEmail
    
    var localizedDescription: String {
        switch self {
        case .required(let field):
            "Required field \(field)"
        case .badEmail:
            "Invalid email address"
        }
    }
}
