//
//  User.swift
//  UserApp
//
//  Created by Vivek M on 27/11/23.
//

import Foundation

/*
 
 Example:

 {"id":5775144,"name":"Aamod Marar","email":"marar_aamod@huel.example","gender":"male","status":"active"}
 
*/

struct User: Decodable {
    enum Gender: String, Codable, CaseIterable {
        case male
        case female
        
        var title: String {
            switch self {
            case .male:
                "Male"
            case .female:
                "Female"
            }
        }
    }
    
    enum Status: String, Codable {
        case active
        case inactive
        
        var title: String {
            switch self {
            case .active:
                "Active"
            case .inactive:
                "Inactive"
            }
        }
    }
    
    let id: Int
    let name: String
    let email: String
    let gender: Gender
    let status: Status
}
