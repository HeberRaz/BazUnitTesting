//
//  PokedexMainRemoteDataManagerTests.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 04/11/22.
//

import XCTest
@testable import UnitTestingBaz

class ServiceAPITests: XCTestCase {
    private var sut: ServiceAPI!
    private var urlSessionMock: URLSessionMock!
    
    override func setUp() {
        super.setUp()
        urlSessionMock = URLSessionMock()
        sut = ServiceAPI(session: urlSessionMock)
//        sut = PokedexMainRemoteDataManager(service: service)
    }
    
    override func tearDown() {
        sut = nil
        urlSessionMock = nil
        super.tearDown()
    }
    
    
    func test_getPokemonRequest_returnsCorrectURL() {
        // Given
        let mockedName: String = "nameMock"
        // When
        sut.get(.pokemon(nameOrId: mockedName)) { (result: Result<PokemonDetail, Error>) in }
        // Then
        XCTAssertEqual(Endpoint.baseURL + mockedName, urlSessionMock.url?.absoluteString)
    }
    
    func test_getNextPokemonBlockRequest_returnsCorrectURL() {
        // Given
        let nextUrl: String = "nexturl.mock"
        // When
        sut.get(.next(urlString: nextUrl)) { (result: Result<PokemonDetail, Error>) in }
        // Then
        XCTAssertEqual(nextUrl, urlSessionMock.url?.absoluteString)
    }
    
    func testNetworkResponse() {
        // Given
        let expectation = expectation(description: "pokemon service expectation")
        var response = false
        
        // When
        sut.get(.pokemon(nameOrId: "nameMock")) { (result: Result<PokemonDetail, Error>) in
            response = true
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(response)
    }
    
    func testResponseWithError() {
        // Given
        let expectation = expectation(description: "pokemon service expectation")
        var expectedError: ServiceError?
        urlSessionMock.error = ServiceError.response
        
        // When
        sut.get(.pokemon(nameOrId: "nameMock")) { (result: Result<PokemonDetail, Error>) in
            switch result {
            case .failure(let error):
                expectedError = error as? ServiceError
                expectation.fulfill()
            default:
                break
            }
            print(result)
        }
        wait(for: [expectation], timeout: 0.1)
        XCTAssertNotNil(expectedError)
    }
    
    func testResponseWithNoData() throws {
        // Given
        let expectation = expectation(description: "pokemon service expectation")
        var expectedError: ServiceError?
        
        // When
        sut.get(.pokemon(nameOrId: "nameMock")) { (result: Result<PokemonDetail, Error>) in
            switch result {
            case .failure(let error):
                expectedError = error as? ServiceError
                expectation.fulfill()
            default:
                break
            }
            print(result)
        }
        wait(for: [expectation], timeout: 0.1)
        let unwrappedError = try XCTUnwrap(expectedError)
        XCTAssertEqual(unwrappedError, .noData)
    }
    
    func testResponseWithFailingStatusCode() throws {
        // Given
        let expectation = expectation(description: "pokemon service expectation")
        var expectedError: ServiceError?
        urlSessionMock.urlResponse = HTTPURLResponse(
            url: Endpoint.pokemon(nameOrId: "").request.url!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil)
        urlSessionMock.data = Data()
        
        // When
        sut.get(.pokemon(nameOrId: "nameMock")) { (result: Result<PokemonDetail, Error>) in
            switch result {
            case .failure(let error):
                expectedError = error as? ServiceError
                expectation.fulfill()
            default:
                break
            }
        }
        wait(for: [expectation], timeout: 0.1)
        let unwrappedError = try XCTUnwrap(expectedError)
        XCTAssertEqual(unwrappedError, .internalServer)
    }
    
    func testRequestWithResponseError() throws {
        // Given
        let expectation = expectation(description: "pokemon service expectation")
        var expectedError: ServiceError?
        urlSessionMock.data = Data()
        
        // When
        sut.get(.pokemon(nameOrId: "nameMock")) { (result: Result<PokemonDetail, Error>) in
            switch result {
            case .failure(let error):
                expectedError = error as? ServiceError
                expectation.fulfill()
            default:
                break
            }
        }
        wait(for: [expectation], timeout: 0.1)
        let unwrappedError = try XCTUnwrap(expectedError)
        XCTAssertEqual(unwrappedError, .response)
    }
    
    func testResponseWithParsingError() throws {
        // Given
        let expectation = expectation(description: "pokemon service expectation")
        var expectedError: ServiceError?
        urlSessionMock.data = Data()
        urlSessionMock.urlResponse = HTTPURLResponse()
        
        // When
        sut.get(.pokemon(nameOrId: "nameMock")) { (result: Result<PokemonDetail, Error>) in
            switch result {
            case .failure(let error):
                expectedError = error as? ServiceError
                
                expectation.fulfill()
            default:
                break
            }
            print(result)
        }
        wait(for: [expectation], timeout: 0.1)
        let unwrappedError = try XCTUnwrap(expectedError)
        XCTAssertEqual(unwrappedError, .parsingData)
    }
    
    func testResponseWithParsingSuccess() throws {
        // Given
        let expectation = expectation(description: "pokemon service expectation")
        urlSessionMock.data = PokedexDummy().blockData
        urlSessionMock.urlResponse = HTTPURLResponse()
        var pokemonBlock: PokemonBlock?
        
        // When
        sut.get(.next(urlString: "https://blockFake")) { (result: Result<PokemonBlock, Error>) in
            switch result {
            case .success(let block):
                pokemonBlock = block
                expectation.fulfill()
            default:
                break
            }
            print(result)
        }
        wait(for: [expectation], timeout: 0.1)
        let decodedDataCount: Int = try XCTUnwrap(pokemonBlock?.count)
        // Then
        XCTAssertTrue(decodedDataCount != 0)
    }
}

