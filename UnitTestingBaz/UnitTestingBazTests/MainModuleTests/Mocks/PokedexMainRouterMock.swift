//
//  PokedexMainRouterMock.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import UIKit
@testable import UnitTestingBaz

enum PokedexMainRouterMockCalls {
    case createPokedexMainModule
    case presentPokemonDetail
    case showAlert
}

final class PokedexMainRouterMock: PokedexMainRouterProtocol {
    
    // MARK: - Protocol properties
    
    var view: PokedexMainViewControllerProtocol?
    var interactor: (PokedexMainInteractorInputProtocol & PokedexRemoteDataOutputProtocol)?
    var presenter: (PokedexMainInteractorOutputProtocol & PokedexMainPresenterProtocol)?
    var router: PokedexMainRouterProtocol?
    var remoteData: PokedexMainRemoteDataInputProtocol?
    
    // MARK: - Class properties
    var calls: [PokedexMainRouterMockCalls] = []
    var pokemonName: String?
    
    // MARK: - Protocol methods
    
    func createPokedexMainModule() -> UINavigationController {
        calls.append(.createPokedexMainModule)
        return UINavigationController()
    }
    
    func presentPokemonDetail(named pokemonName: String) {
        calls.append(.presentPokemonDetail)
        self.pokemonName = pokemonName
    }
    
    func showAlert(with alertModel: AlertModel, handler: @escaping () -> Void) {
        calls.append(.showAlert)
        handler()
    }
}
