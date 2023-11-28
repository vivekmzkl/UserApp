//
//  CreateUserParam.swift
//  UserApp
//
//  Created by Vivek M on 27/11/23.
//

import Foundation

/*
 
 Example:

 POST
 
 {"name":"Tenali Ramakrishna", "gender":"male", "email":"tenali.ramakrishna@15ce.com", "status":"active"}
 
*/

struct CreateUserParam: Encodable {
    let name: String
    let email: String
    let gender: User.Gender
    let status: User.Status    
}
