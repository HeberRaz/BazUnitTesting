//
//  ServiceAPIMock.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import Foundation
@testable import UnitTestingBaz

final class ServiceAPIMock: ServiceApiProtocol {
    
    var session: URLSessionProtocol = URLSessionMock()
    
    func get<T>(_ endpoint: Endpoint, callback: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let sessionMock: URLSessionMock = session as! URLSessionMock
        ServiceAPI(session: sessionMock).get(endpoint, callback: callback)
    }
}
