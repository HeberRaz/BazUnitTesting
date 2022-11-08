//
//  PokedexMainInteractorTests.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import XCTest
@testable import UnitTestingBaz


final class PokedexMainInteractorTests: XCTestCase {
    private var sut: PokedexMainInteractor!
    private var presenterMock: PokedexMainPresenterMock!
    private var remoteDataManagerMock: PokedexMainRemoteDataManagerMock!
    
    override func setUp() {
        super.setUp()
        sut = PokedexMainInteractor()
        presenterMock = PokedexMainPresenterMock()
        remoteDataManagerMock = PokedexMainRemoteDataManagerMock()
        sut.presenter = presenterMock
        sut.remoteData = remoteDataManagerMock
    }
    
    override func tearDown() {
        sut = nil
        presenterMock = nil
        remoteDataManagerMock = nil
        super.tearDown()
    }
    
    func testFetchPokemonBlock_callsRemoteDataManager_andSendsACompleteUrlString() {
        // Given
        let mockedUrl: String = "https://www.fakeurl.mock"
        // When
        sut.fetchPokemonBlock(mockedUrl)
        // Then
        XCTAssert(remoteDataManagerMock.calls.contains(.requestPokemonBlock))
        XCTAssertEqual(remoteDataManagerMock.urlString, mockedUrl)
    }
    
    func testFetchDetail_callsRemoteDataManager_andSendsAPokemonName() {
        // Given
        let mockedPokemonName: String = "pokemon-name"
        // When
        sut.fetchDetailFrom(pokemonName: mockedPokemonName)
        // Then
        XCTAssert(remoteDataManagerMock.calls.contains(.requestPokemon))
        XCTAssertEqual(remoteDataManagerMock.pokemonName, mockedPokemonName)
    }
    
    func testHandlePokemonBlock_setsFetchInProgressToFalse() throws {
        // Given
        let pokemonBlock: PokemonBlock = try JSONDecoder().decode(PokemonBlock.self, from: PokedexDummy().blockData)
        // When
        sut.handlePokemonBlockFetch(pokemonBlock)
        // Then
        XCTAssertEqual(presenterMock.isFetchInProgress, false)
    }
    
    func testHandlePokemonBlock_callsPresenterOnRecievedData() throws {
        // Given
        let pokemonBlock: PokemonBlock = try JSONDecoder().decode(PokemonBlock.self, from: PokedexDummy().blockData)
        // When
        sut.handlePokemonBlockFetch(pokemonBlock)
        // Then
        XCTAssert(presenterMock.calls.contains(.onReceivedData))
    }
    
    func testHandleFetchedPokemon_whenObtainsImageData_passesPokemonDataToPresenter() throws {
        // Given
        let pokemonDetail: PokemonDetail = try JSONDecoder().decode(PokemonDetail.self, from: PokedexDummy().detailData)
        // When
        sut.handleFetchedPokemon(pokemonDetail)
        // Then
        XCTAssert(presenterMock.calls.contains(.onReceivedPokemon))
    }
    
    func testHandleFetchedPokemon_whenCannotObtainImageData_returnsFunction() throws {
        // Given
        let pokemonDetail: PokemonDetail = PokemonDetail(id: 1,
                                                         name: "mocked name",
                                                         sprites: PokemonSprites(frontDefault: "invalidUrl.jpg"))
        // When
        sut.handleFetchedPokemon(pokemonDetail)
        // Then
        XCTAssertFalse(presenterMock.calls.contains(.onReceivedPokemon))
        XCTAssert(presenterMock.calls.isEmpty)
    }
    
    func testHandleServiceError_buildsAlertModel_andCallsPresenterToShowIt() {
        // Given
        let error: ServiceError = .internalServer
        // When
        sut.handleService(error: error)
        // Then
        XCTAssert(presenterMock.calls.contains(.willShowAlert))
        XCTAssertEqual(presenterMock.alertModel?.title, "Internal server error")
        XCTAssertEqual(presenterMock.alertModel?.message, "Please wait")
    }
}
