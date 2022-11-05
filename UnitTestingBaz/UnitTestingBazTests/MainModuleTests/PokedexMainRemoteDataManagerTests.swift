//
//  PokedexMainRemoteDataManagerTests.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 04/11/22.
//

import XCTest
@testable import UnitTestingBaz

class PokedexMainRemoteDataManagerTests: XCTestCase {
    private var sut: PokedexMainRemoteDataInputProtocol!

    override func setUp() {
        super.setUp()
        sut = PokedexMainRemoteDataManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test() {
        
    }
}
