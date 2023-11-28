//
//  HTTPHeader.swift
//  UserApp
//
//  Created by Vivek M on 27/11/23.
//

import Foundation

public enum HTTPHeader {
    case authorization(token: String?)
    case acceptJson
    case jsonContentType
    
    var key: String {
        switch self {
        case .authorization:
            return "Authorization"
        case .acceptJson:
            return "Accept"
        case .jsonContentType:
            return "Content-Type"
        }
    }
    
    func getValue() -> String? {
        switch self {
        case .authorization(token: let token):
            if let token = token {
                return "Bearer " + token
            }
            return nil
        case .acceptJson:
            return "application/json"
        case .jsonContentType:
            return "application/json"
        }
    }
}


