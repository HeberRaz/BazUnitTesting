//
//  URLSessionMock.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import Foundation
@testable import UnitTestingBaz

class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    var url: URL?
    var dataTask: URLSessionDataTaskProtocol = URLSessionDataTaskMock()
    
    func performDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        url = request.url
        completionHandler(data, urlResponse, error)
        return dataTask
    }
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    func resume() { }
}
