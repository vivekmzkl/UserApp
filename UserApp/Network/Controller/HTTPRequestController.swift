//
//  HTTPRequestController.swift
//  UserApp
//
//  Created by Vivek M on 27/11/23.
//
import Foundation

//[{"field":"email","message":"has already been taken"}] -> 422
//
//{"message":"Invalid token"} -> 401
//
//{"id":5781552,"name":"Tenali Ramakrishna","email":"tenali.ramakrishnan@15ce.com","gender":"male","status":"active"} -> 201

struct HTTPRequestController {
    static func httpRequest<T: Decodable>(request: APIRequest, decodable responseType: T.Type) async -> Result<T, Error> {
        var urlRequest = URLRequest(url: request.url())
        urlRequest.httpMethod = request.method.rawValue
        #if DEBUG
        print("Headers::")
        #endif
        request.headers.forEach {
            urlRequest.setValue($0.getValue(), forHTTPHeaderField: $0.key)
            #if DEBUG
            print("\($0.key): \($0.getValue() ?? "")")
            #endif
        }
        urlRequest.httpBody = request.body()
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse else {
                #if DEBUG
                print("RequestController - Response: Invalid HTTP Response")
                #endif
                return .failure(APIError.invalidHTTPResponse)
            }
            
            #if DEBUG
            print("RequestController - Response: \(httpResponse)")
            #endif
            
            switch httpResponse.statusCode {
            case 200...299: //success
                let decoder = JSONDecoder()
                let model = try decoder.decode(responseType, from: data)
                return .success(model)
                
            case 401: //unauthorized
                return .failure(APIError.unauthorizedAccess)
                
            case 422: // Data validation failed (in response to a POST request, for example). Please check the response body for detailed error messages.
                let decoder = JSONDecoder()
                let model = try decoder.decode([FieldError].self, from: data)
                return .failure(APIError.fieldError(errors: model))
                
            default:
                #if DEBUG
                print("RequestController - Response: HTTP Error: \(httpResponse.statusCode)")
                #endif
                return .failure(APIError.errorStatusCode(statusCode: httpResponse.statusCode))
            }
        } catch {
            #if DEBUG
            print("RequestController - Failure: \(error)")
            #endif
            return .failure(error)
        }
    }
}
