//
//  APIError.swift
//  UserApp
//
//  Created by Vivek M on 27/11/23.
//

import Foundation

enum APIError: Error {
    case parseError(message: String)
    case unknownResponseStructure
    case internalFailure(message: String, errorCode: Int)
    case requestFailed(message: String)
    case invalidHTTPResponse
    case errorStatusCode(statusCode: Int)
    case unauthorizedAccess
    case fieldError(errors: [FieldError])
    
    var localizedDescription: String {
        switch self {
        case .parseError(let message):
            return "Parsing failed: \(message)"
        case .unknownResponseStructure:
            return "unknownResponseStructure"
        case .internalFailure(let message, _):
            return message
        case .requestFailed(let message):
            return message
        case .invalidHTTPResponse:
            return "invalidHTTPResponse"
        case .errorStatusCode(let statusCode):
            return "Invalid Status Code: \(statusCode)"
        case .unauthorizedAccess:
            return "unauthorizedAccess"
        case .fieldError(errors: let errors):
            var message =  ""
            errors.forEach { error in
                message.append(error.field + " " + error.message + "\n")
            }
            return message
        }
    }
    
    var errorCode: Int? {
        switch self {
        case .internalFailure(_, let errorCode):
            return errorCode
        default:
            return nil
        }
    }
    
    var statusCode: Int? {
        switch self {
        case .errorStatusCode(let statusCode):
            return statusCode
        default:
            return nil
        }
    }
}
