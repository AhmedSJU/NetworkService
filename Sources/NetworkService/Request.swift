//
//  File.swift
//  
//
//  Created by Sheikh Ahmed on 28/05/2022.
//

import Foundation
import Combine

public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
    associatedtype ReturnType: Codable
}

// MARK: - Defaults
extension Request {
    var method: HTTPMethod { .GET }
    var contentType: String { "application/json" }
    var queryParameters: [String: String]? { nil }
    var body: [String: Any]? { nil }
    var headers: [String: String]? { nil }
}

// MARK: - Serialize the request
extension Request {
    private func requestBodyFrom(parameters: [String: Any]?) -> Data? {
        guard let parameters = parameters else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return nil }
        return httpBody
    }
    
    func asURLRequest(baseURL: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        guard let finalURL = urlComponents.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(parameters: body)
        request.allHTTPHeaderFields = headers
        return request
        
    }
}
