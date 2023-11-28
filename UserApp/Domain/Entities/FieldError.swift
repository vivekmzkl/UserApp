//
//  FieldError.swift
//  UserApp
//
//  Created by Vivek M on 27/11/23.
//

import Foundation

struct FieldError: Decodable {
    let field: String
    let message: String
}
