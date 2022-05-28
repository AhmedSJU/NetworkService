//
//  File.swift
//  
//
//  Created by Sheikh Ahmed on 28/05/2022.
//

import Foundation
import Combine

public protocol Requestable {
    var requestTimeOut: Float { get }
    
    func request<T: Codable>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError>
}
