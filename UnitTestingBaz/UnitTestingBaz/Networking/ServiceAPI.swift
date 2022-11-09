//
//  ServiceAPI.swift
//  UnitTestingBaz
//
//  Created by Heber Raziel Alvarez Ruedas on 31/10/22.
//

import Foundation

enum ServiceError: Error {
    case noData
    case response
    case parsingData
    case internalServer
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {
    func performDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

protocol URLSessionProtocol { typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func performDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol ServiceApiProtocol {
    var session: URLSessionProtocol { get }
    func get<T: Decodable>(_ endpoint: Endpoint, callback: @escaping (Result<T,Error>) -> Void)
}

class ServiceAPI: ServiceApiProtocol {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get<T: Decodable>(_ endpoint: Endpoint, callback: @escaping (Result<T,Error>) -> Void) {
        let request = endpoint.request
        let task = session.performDataTask(with: request) { (data, response, error) in
            self.handleRequest(data: data, response: response, error: error, callback: callback)
        }
        task.resume()
    }
    
    private func handleRequest<T:Decodable>(data: Data?, response: URLResponse?, error: Error?, callback: (Result<T, Error>) -> Void)  {
        if let error: Error = error {
            callback(.failure(error))
            return
        }
        
        guard let data: Data = data else {
            callback(.failure(ServiceError.noData))
            return
        }
        
        guard let response: HTTPURLResponse = response as? HTTPURLResponse else {
            callback(.failure(ServiceError.response))
            return
        }
        
        guard (200 ... 299) ~= response.statusCode else {
            print("statusCode should be 2xx, but is \(response.statusCode)")
            print("response = \(response)")
            callback(.failure(ServiceError.internalServer))
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            callback(.success(decodedData))
            
        } catch {
            callback(.failure(ServiceError.parsingData))
        }
    }
}
