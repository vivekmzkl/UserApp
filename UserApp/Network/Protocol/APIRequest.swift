//
//  APIRequest.swift
//  UserApp
//
//  Created by Vivek M on 27/11/23.
//

import Foundation

protocol APIRequest {
    //HTTP method
    var method: HTTPMethod { get }
    
    //API Endpoint
    var endpoint: String { get }
    
    //API Params
    var encodable: Encodable? { get }
    
    //API request handler
    func result<T: Decodable>(decodableType: T.Type) async -> Result<T, APIError>
}

extension APIRequest {
    var headers: [HTTPHeader] {
        [.acceptJson,
         .jsonContentType,
         .authorization(token: "61cbde7fc88eb29a1f6468a6ebb7848191dac1d3656f70d2d69ad6532eacf27e")
        ]
    }
        
    func result<T: Decodable>(decodableType: T.Type) async -> Result<T, APIError> {
        let result = await HTTPRequestController.httpRequest(request: self, decodable: decodableType)
        switch result {
        case .success(let success):
            return .success(success)
        case .failure(let failure):
            if let error = failure as? APIError {
                return .failure(error)
            }
            return .failure(APIError.internalFailure(message: failure.localizedDescription, errorCode: -1))
        }
    }
    
    func url() -> URL {
        guard let url = URL(string: generateUrl) else {
            fatalError("URL Generation failed")
        }
        
        return url
    }
    
    func body() -> Data? {
        guard let encodable = self.encodable else { return nil }
        let encoder = JSONEncoder()
        print("PARAMS:: \(encodable)")
        do {
            return try encoder.encode(encodable)
        } catch {
            #if DEBUG
            print("APIRequest: body() creation failed")
            #endif
            return nil
        }
    }
}

extension APIRequest {
    private func addUrlDivision(string: String) -> String {
        return string + "/"
    }
    
    private var generateUrl: String {
        let baseUrl = "https://gorest.co.in/public/v2/"
        let url = baseUrl + self.endpoint
        return url.replacingOccurrences(of: "//", with: "/")
    }
}
