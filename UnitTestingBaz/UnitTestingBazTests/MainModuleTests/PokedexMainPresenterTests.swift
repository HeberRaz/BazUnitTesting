//
//  PokedexMainPresenterTests.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import XCTest
@testable import UnitTestingBaz

final class PokedexMainPresenterTests: XCTestCase {
    private var sut: PokedexMainPresenter!
    private var viewMock: PokedexMainViewControllerMock!
    private var routerMock: PokedexMainRouterMock!
    private var interactorMock: PokedexMainInteractorMock!

    override func setUp() {
        super.setUp()
        viewMock = PokedexMainViewControllerMock()
        routerMock = PokedexMainRouterMock()
        interactorMock = PokedexMainInteractorMock()
        sut = PokedexMainPresenter()
        
        sut.view = viewMock
        sut.router = routerMock
        sut.interactor = interactorMock
    }

    override func tearDown() {
        viewMock = nil
        routerMock = nil
        interactorMock = nil
        sut = nil
        super.tearDown()
    }

    func testDidSelectRowAt_callsRouterToPresentDetail_withPokemonNameCapitalized() {
        // Given
        let pokemon: Pokemon = Pokemon(
            from: PokemonDetail(id: 15,
                                name: "Pokemon name mock",
                                sprites: PokemonSprites(frontDefault: "imageUrl.jpg")),
            imageData: Data())
        viewMock.pokemonList = [PokemonCellModel(from: pokemon)]
        let indexPath: IndexPath = IndexPath(row: .zero, section: .zero)
        // When
        sut.didSelectRowAt(indexPath)
        // Then
        XCTAssert(routerMock.calls.contains(.presentPokemonDetail))
        XCTAssertEqual(routerMock.pokemonName, pokemon.name.capitalized)
    }
    
    func testReloadSections_callsViewToRealoadTableView() {
        // When
        sut.reloadSections()
        // Then
        XCTAssert(viewMock.calls.contains(.reloadInformation))
    }
    
    func testWillFetchPokemons() {
        // When
        sut.willFetchPokemons()
        // Then
        XCTAssert(interactorMock.calls.contains(.fetchPokemonBlock))
    }
    
    func testShouldPrefetch_whenModelHasSameNumberOfElementsAsLoadedIndex_callsNewBlock() {
        // Given
        viewMock.pokemonList = generatePokemonCellModels(10)
        let indexPaths: [IndexPath] = generateIndexPaths(10)
        // When
        sut.shouldPrefetch(at: indexPaths)
        // Then
        XCTAssert(interactorMock.calls.contains(.fetchPokemonBlock))
    }
    
    func testShouldPrefetch_whenModelHasSameNumberOfElementsAsLoadedIndex_sendsNextUrl() {
        // Given
        viewMock.pokemonList = generatePokemonCellModels(10)
        interactorMock.nextBlockUrl = "https://nexturl.mock"
        
        let indexPaths: [IndexPath] = generateIndexPaths(10)
        // When
        sut.shouldPrefetch(at: indexPaths)
        // Then
        XCTAssertEqual(interactorMock.catchUrl, interactorMock.nextBlockUrl)
    }
    
    func testShouldPrefetch_whenModelHasSameNumberOfElementsAsLoadedIndex_setsFetchInProgress() {
        // Given
        viewMock.pokemonList = generatePokemonCellModels(10)
        interactorMock.nextBlockUrl = "https://nexturl.mock"
        
        let indexPaths: [IndexPath] = generateIndexPaths(10)
        // When
        sut.shouldPrefetch(at: indexPaths)
        // Then
        XCTAssertEqual(sut.isFetchInProgress, true)
    }
    
    func testShouldPrefetch_whenMoreNumberOfElementsInModelThanLoadedIndex_doesentCallNewBlock() {
        // Given
        viewMock.pokemonList = generatePokemonCellModels(11)
        let indexPaths: [IndexPath] = generateIndexPaths(10)
        // When
        sut.shouldPrefetch(at: indexPaths)
        // Then
        XCTAssertFalse(interactorMock.calls.contains(.fetchPokemonBlock))
    }
    
    func testShouldPrefetch_whenMoreNumberOfElementsInModelThanLoadedIndex_sendsNextUrl() {
        // Given
        viewMock.pokemonList = generatePokemonCellModels(11)
        interactorMock.nextBlockUrl = "https://nexturl.mock"
        
        let indexPaths: [IndexPath] = generateIndexPaths(10)
        // When
        sut.shouldPrefetch(at: indexPaths)
        // Then
        XCTAssertNil(interactorMock.catchUrl)
        XCTAssertFalse(interactorMock.catchUrl ==  interactorMock.nextBlockUrl)
    }
    
    func testShouldPrefetch_whenMoreNumberOfElementsInModelThanLoadedIndex_keepsFetchInProgressFalse() {
        // Given
        viewMock.pokemonList = generatePokemonCellModels(11)
        interactorMock.nextBlockUrl = "https://nexturl.mock"
        
        let indexPaths: [IndexPath] = generateIndexPaths(10)
        // When
        sut.shouldPrefetch(at: indexPaths)
        // Then
        XCTAssertEqual(sut.isFetchInProgress, false)
    }
    
    func testWillShowAlert() {
        // Given
        let alertModel: AlertModel = AlertModel(serviceError: .internalServer)
        // When
        sut.willShowAlert(with: alertModel)
        // Then
        
    }
    
    // MARK: Helper functions
    
    private func generateIndexPaths(_ number: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for i in 0..<number {
            indexPaths.append(IndexPath(row: i, section: .zero))
        }
        return indexPaths
    }
    
    private func generatePokemonCellModels(_ number: Int) -> [PokemonCellModel] {
        var pokemonCellModels: [PokemonCellModel] = []
        for i in 1..<number {
            pokemonCellModels.append(PokemonCellModel(from: Pokemon(
                from: PokemonDetail(
                    id: i,
                    name: "Mocked-Pokemon-\(i)",
                    sprites: PokemonSprites(frontDefault: "mockedimage\(i)url.jpg")),
                imageData: Data())))
            
        }
        return pokemonCellModels
    }
}
