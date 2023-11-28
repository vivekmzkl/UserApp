//
//  LoaderListner.swift
//  UserApp
//
//  Created by Vivek M on 28/11/23.
//

import Foundation

typealias Loader = (_ loading: Bool) -> Void

protocol LoaderListner {
    var loader: Loader? { get set }
    func subscribe(loader: Loader?)
}
