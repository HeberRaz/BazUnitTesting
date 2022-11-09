//
//  PokedexMainViewControllerTests.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 08/11/22.
//

import XCTest
@testable import UnitTestingBaz

final class PokedexMainViewControllerTests: XCTestCase {
    private var sut: PokedexMainViewController!
    private var presenterMock: PokedexMainPresenterMock!
    
    override func setUp() {
        super.setUp()
        presenterMock = PokedexMainPresenterMock()
        sut = PokedexMainViewController()
        
        sut.presenter = presenterMock
    }
    
    override func tearDown() {
        presenterMock = nil
        sut = nil
        super.tearDown()
    }
    
    func testViewDidLoad_callsWillFetchPokemons() {
        // When
        sut.viewDidLoad()
        // Then
        XCTAssert(presenterMock.calls.contains(.willFetchPokemons))
    }
    
    func testViewWillAppear_setsBackgroundToWhite() {
        // When
        sut.viewWillAppear(true)
        // Then
        XCTAssertEqual(sut.view.backgroundColor, .white)
    }
    
    func testViewWillAppear_setsViewTitle() {
        // When
        sut.viewWillAppear(true)
        // Then
        XCTAssertEqual(sut.title, "Pokemon")
    }
    
    func testViewWillAppear_addsTableView() throws {
        // When
        sut.viewWillAppear(true)
        let tableView: UITableView = try XCTUnwrap(sut.view.subviews.first as? UITableView, "First subview should be a tableView")
        // Then
        XCTAssertNotNil(tableView)
    }
    
    func testTableView_whenViewWillAppear_setsInitialConfiguration() throws {
        // When
        sut.viewWillAppear(true)
        let tableView: UITableView = try XCTUnwrap(sut.view.subviews.first as? UITableView, "First subview should be a tableView")
        // Then
        XCTAssertEqual(tableView.separatorStyle, .none)
        XCTAssert(tableView.delegate === sut)
        XCTAssert(tableView.dataSource === sut)
        XCTAssert(tableView.prefetchDataSource === sut)
    }
    
    func testTableViewDelegate_didSelectRowAt_callsPresenterMethod() throws {
        // Given
        sut.viewWillAppear(true)
        let indexPath: IndexPath = IndexPath(row: .zero, section: .zero)
        // When
        let tableView: UITableView = try XCTUnwrap(sut.view.subviews.first as? UITableView, "First subview should be a tableView")
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        // Then
        XCTAssert(presenterMock.calls.contains(.didSelectRowAt))
    }
    
    func testFillPokemonList_whenPresenterModelHasElements_callsToReloadSections() throws {
        // Given
        presenterMock.model = [Pokemon(
            from: PokemonDetail(id: 1,
                                name: "Pokemon mock",
                                sprites: PokemonSprites(frontDefault: "urlimage.jpg")),
            imageData: Data())]
        // When
        sut.fillPokemonList()
        // Then
        XCTAssert(presenterMock.calls.contains(.reloadSections))
        
    }
    
    func testFillPokemonList_whenPresenterModelHasElements_sortsThemById() throws {
        // Given
        sut.pokemonList = [
            PokemonCellModel(from: Pokemon(from: PokemonDetail(id: 2,
                                                               name: "Pokemon mock",
                                                               sprites: PokemonSprites(frontDefault: "urlimage.jpg")),
                                           imageData: Data())),
            PokemonCellModel(from: Pokemon(from: PokemonDetail(id: 1,
                                                               name: "Pokemon mock",
                                                               sprites: PokemonSprites(frontDefault: "urlimage.jpg")),
                                           imageData: Data()))
        ]
        presenterMock.model = [
            Pokemon(from: PokemonDetail(id: 3,
                                        name: "Pokemon mock",
                                        sprites: PokemonSprites(frontDefault: "urlimage.jpg")),
                    imageData: Data())
        ]
        // When
        sut.fillPokemonList()
        // Then
        XCTAssertEqual(sut.pokemonList[0].id, 1)
        XCTAssertEqual(sut.pokemonList[1].id, 2)
        XCTAssertEqual(sut.pokemonList[2].id, 3)
    }
    
    func testTableView_whenPrefetchRowsAt_callsPresenterMethod() throws {
        // Given
        sut.viewWillAppear(true)
        // When
        let tableView: UITableView = try XCTUnwrap(sut.view.subviews.first as? UITableView, "First subview should be a tableView")
        tableView.prefetchDataSource?.tableView(tableView, prefetchRowsAt: [IndexPath(row: 5, section: 0)])
        // Then
        XCTAssert(presenterMock.calls.contains(.shouldPrefetch))
    }
    
    func testPokemonList_whenCountLessThanTotalPokemons_addsTwentyToCurrentCount() throws {
        // Given
        sut.pokemonList = [
            PokemonCellModel(from: Pokemon(from: PokemonDetail(id: 2,
                                                               name: "Pokemon mock",
                                                               sprites: PokemonSprites(frontDefault: "urlimage.jpg")),
                                           imageData: Data())),
            PokemonCellModel(from: Pokemon(from: PokemonDetail(id: 1,
                                                               name: "Pokemon mock",
                                                               sprites: PokemonSprites(frontDefault: "urlimage.jpg")),
                                           imageData: Data()))
        ]
        // When
        sut.viewWillAppear(true)
        let tableView: UITableView = try XCTUnwrap(sut.view.subviews.first as? UITableView, "First subview should be a tableView")
        tableView.dataSource?.tableView(tableView, numberOfRowsInSection: .zero)
        // Then
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), sut.pokemonList.count + 20)
    }
    
    func testPokemonList_whenCountIsTotalPokemons_returnsTotalCount() throws {
        // Given
        presenterMock.totalPokemonCount = 10
        sut.pokemonList = generatePokemonsInModel(10)
        // When
        sut.viewWillAppear(true)
        let tableView: UITableView = try XCTUnwrap(sut.view.subviews.first as? UITableView, "First subview should be a tableView")
        tableView.dataSource?.tableView(tableView, numberOfRowsInSection: .zero)
        // Then
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), sut.pokemonList.count)
    }
    
    func testCellForRow_whenLoadedData_configuresCell() throws {
        // Given
        sut.pokemonList = generatePokemonsInModel(1)
        presenterMock.isLoadingCell = false
        sut.viewWillAppear(true)
        // When
        let tableView: UITableView = try XCTUnwrap(sut.view.subviews.first as? UITableView, "First subview should be a tableView")
        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: .zero, section: .zero))
        let innerContentView = (cell as? PokemonCell)?.subviews.last?.subviews.first
        let cellRibbon = try XCTUnwrap(innerContentView?.subviews.first)
        let ribbonLabel = try XCTUnwrap(cellRibbon.subviews.last as? UILabel)
        let cellLabel = try XCTUnwrap((innerContentView?.subviews[1] as? UILabel))
        
        // Then
        XCTAssertEqual(cellLabel.text, sut.pokemonList.first?.name)
        XCTAssertEqual(ribbonLabel.text!, "No. \(sut.pokemonList.first!.id)")
    }
    
    // MARK: - Helper Functions
    private func generatePokemonsInModel(_ number: Int) -> [PokemonCellModel] {
        var pokemonModel: [PokemonCellModel] = []
        for i in 0..<number {
            pokemonModel.append(
                PokemonCellModel(from: Pokemon(
                    from: PokemonDetail(
                        id: i,
                        name: "Mocked-Pokemon-\(i)",
                        sprites: PokemonSprites(frontDefault: "mockedimage\(i)url.jpg")),
                    imageData: Data())))
        }
        return pokemonModel
    }
    
}

