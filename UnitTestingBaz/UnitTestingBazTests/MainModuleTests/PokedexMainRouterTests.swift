//
//  PokedexMainRouterTests.swift
//  PokedexMainRouterTests
//
//  Created by Heber Raziel Alvarez Ruedas on 04/11/22.
//

import XCTest
@testable import UnitTestingBaz

class PokedexMainRouterTests: XCTestCase {
    private var sut: PokedexMainRouterProtocol!
    private var viewMock: PokedexMainViewControllerMock!

    override func setUp() {
        super.setUp()
        viewMock = PokedexMainViewControllerMock()
        sut = PokedexMainRouter()
        sut.view = viewMock
    }

    override func tearDown() {
        sut = nil
        viewMock = nil
        super.tearDown()
    }

    func testMainRouter_whenCreateTransverseSearchModule_returnsNotNilInitialProperties() {
        // Given
        /// Note: - Se colocan condiciones iniciales, o elementos que ayudan a comparar la comprobación final
        // When
        /// Note: - El llamado a la función a testear o probar
        _ = sut.createPokedexMainModule()
        // Then
        /// Note: - Se colocan los asserts
        XCTAssertNotNil(sut.view)
        XCTAssertNotNil(sut.interactor)
        XCTAssertNotNil(sut.presenter)
        XCTAssertNotNil(sut.remoteData)
        XCTAssertNotNil(self)
    }
    
    func testPresentPokemonDetail_asDetailViewController_pushesModuleCorrectly() throws {
        // Given
        let pokemonName: String = "Pikachu"
        let viewController: UIViewController = try XCTUnwrap(sut.view as? UIViewController)
        let mockNavigationController = SpyNavigationController(rootViewController: viewController)
        // When
        sut.presentPokemonDetail(named: pokemonName)
        let detailViewController = try XCTUnwrap(mockNavigationController.pushedViewController as? PokedexDetailViewController, "La función 'presentPokemonDetail' debe presentar un viewController del tipo PokedexDetailViewController")
        // Then
        XCTAssertNotNil(detailViewController)
    }
    
    func testPresentPokemonDetail_isOfTypePokemonDetailViewController() throws {
        // Given
        let pokemonName: String = "Pikachu"
        let viewController: UIViewController = try XCTUnwrap(sut.view as? UIViewController)
        let mockNavigationController = SpyNavigationController(rootViewController: viewController)
        // When
        sut.presentPokemonDetail(named: pokemonName)
        // Then
        XCTAssert(mockNavigationController.pushedViewController is PokedexDetailViewController)
    }
    
    func testPresentPokemonDetail_whenNotCastedAsDetailViewController_returnsFalse() throws {
        // Given
        let pokemonName: String = "Pikachu"
        let viewController: UIViewController = try XCTUnwrap(sut.view as? UIViewController)
        let mockNavigationController = SpyNavigationController(rootViewController: viewController)
        // When
        sut.presentPokemonDetail(named: pokemonName)
        // Then
        XCTAssertFalse(mockNavigationController.pushedViewController is PokedexMainViewController)
    }
}

import UIKit
 
class SpyNavigationController: UINavigationController {
    
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: true)
    }
}
