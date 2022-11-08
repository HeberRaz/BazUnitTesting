//
//  PokedexMainRemoteDataManagerTests.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import XCTest
@testable import UnitTestingBaz

class PokedexMainRemoteDataManagerTests: XCTestCase {
    private var sut: PokedexMainRemoteDataManager!
    private var serviceMock: ServiceAPIMock!
    private var urlSessionMock: URLSessionMock!
    private var interactorMock: PokedexMainInteractorMock!
    
    override func setUp() {
        super.setUp()
        serviceMock = ServiceAPIMock()
        urlSessionMock = URLSessionMock()
        interactorMock = PokedexMainInteractorMock()
        sut = PokedexMainRemoteDataManager(service: ServiceAPI(session: urlSessionMock))
        sut.interactor = interactorMock
    }
    
    override func tearDown() {
        sut = nil
        serviceMock = nil
        urlSessionMock = nil
        interactorMock = nil
        super.tearDown()
    }
    
    
    func testRequestPokemonBlock_whenParsedSuccessfully_callsInteractorHandler() throws {
        // Given
        urlSessionMock.urlResponse = HTTPURLResponse()
        urlSessionMock.data = PokedexDummy().blockData
        // When
        sut.requestPokemonBlock("fakeString")
        // Then
        XCTAssert(interactorMock.calls.contains(.handlePokemonBlockFetch))
    }
    
    func testRequestPokemonBlock_whenJsonAndModelDontMatch_returnsError() throws {
        // Given
        urlSessionMock.urlResponse = HTTPURLResponse()
        urlSessionMock.data = PokedexDummy().jsonMismatch
        // When
        sut.requestPokemonBlock("fakeString")
        // Then
        XCTAssert(interactorMock.calls.contains(.handleServiceError))
        XCTAssertEqual(interactorMock.error, ServiceError.parsingData)
    }
    
    func testRequestPokemonBlock_whenParsedUnsuccessfully_callsErrorHandler() throws {
        // Given
        urlSessionMock.urlResponse = HTTPURLResponse()
        urlSessionMock.error = ServiceError.internalServer
        // When
        sut.requestPokemonBlock("fakeString")
        // Then
        XCTAssert(interactorMock.calls.contains(.handleServiceError))
    }
    
    func testRequestPokemonDetail_whenParsedSuccessfully_callsInteractorHandler() {
        // Given
        urlSessionMock.urlResponse = HTTPURLResponse()
        urlSessionMock.data = PokedexDummy().detailData
        // When
        sut.requestPokemon("name")
        // Then
        XCTAssert(interactorMock.calls.contains(.handleFetchedPokemon))
    }
    
    func testRequestPokemonDetail_whenParsedUnsuccessfully_callsErrorHandler() {
        // Given
        urlSessionMock.urlResponse = HTTPURLResponse()
        urlSessionMock.error = ServiceError.noData
        // When
        sut.requestPokemon("name")
        // Then
        XCTAssert(interactorMock.calls.contains(.handleServiceError))
    }
}


