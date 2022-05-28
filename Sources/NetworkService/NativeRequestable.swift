//
//  File.swift
//  
//
//  Created by Sheikh Ahmed on 28/05/2022.
//

import Foundation
import Combine

public class NetworkRequestable: Requestable {
    public var requestTimeOut: Float = 30
    public func request<T>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError> where T : Decodable, T : Encodable {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(req.requestTimeOut ?? requestTimeOut)
        guard let url = URL(string: req.url) else {
            return AnyPublisher(Fail<T, NetworkError>(error: .badURL("Invalid URL")))
        }
        return URLSession.shared
            .dataTaskPublisher(for: req.buildURLRequest(with: url))
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw NetworkError.serverError(code: 0, error: "Server Error")
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                NetworkError.invalidJSON(String(describing: error))
            }
            .eraseToAnyPublisher()
    }
}
