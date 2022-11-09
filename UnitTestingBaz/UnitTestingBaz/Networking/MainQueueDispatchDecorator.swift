//
//  MainQueueDispatchDecorator.swift
//  UnitTestingBaz
//
//  Created by Heber Raziel Alvarez Ruedas on 08/11/22.
//

import Foundation

//final class MainQueueDispatchDecorator: ServiceApiProtocol {
//    var session: URLSessionProtocol
//    private let decorator: ServiceApiProtocol
//    
//    init(_ decorator: ServiceApiProtocol) {
//        self.session = URLSession.shared
//        self.decorator = decorator
//    }
//    
//    func get<T:Decodable>(_ endpoint: Endpoint, callback: @escaping (Result<T, Error>) -> Void) {
//        DispatchQueue.global(qos: .background).async {
//            self.decorator.get(endpoint) { (result: Result<T, Error>) in
//                self.guaranteeMainThread {
//                    callback(result)
//                }
//            }
//        }
//    }
//    
//    private func guaranteeMainThread(_ work: @escaping () -> Void) {
//        if Thread.isMainThread {
//            work()
//        } else {
//            DispatchQueue.main.async(execute: work)
//        }
//    }
//}
