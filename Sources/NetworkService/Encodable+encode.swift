//
//  File.swift
//  
//
//  Created by Sheikh Ahmed on 28/05/2022.
//

import Foundation
extension Encodable {
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}
