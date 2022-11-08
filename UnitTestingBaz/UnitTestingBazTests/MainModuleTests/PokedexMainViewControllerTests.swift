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
    
    func test() throws {
        // Given
        
    }
}

