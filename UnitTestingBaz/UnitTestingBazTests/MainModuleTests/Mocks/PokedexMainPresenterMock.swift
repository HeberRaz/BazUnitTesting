//
//  PokedexMainPresenterMock.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import Foundation
@testable import UnitTestingBaz

enum PokedexMainPresenterMockCalls {
    case didSelectRowAt
    case shouldPrefetch
    case isLoadingCell
    case reloadSections
    case willFetchPokemons
    case willShowAlert
    case onReceivedData
    case onReceivedPokemon
}

final class PokedexMainPresenterMock {
    
    // MARK: - PresenterProtocol properties
    var view: PokedexMainViewControllerProtocol?
    var router: PokedexMainRouterProtocol?
    
    var model: [Pokemon] = []
    var totalPokemonCount: Int?
    
    // MARK: - InteractorOutputProtocol properties
    var interactor: PokedexMainInteractorInputProtocol?
    
    var isFetchInProgress: Bool = false
    
    // MARK: - Properties
    var calls: [PokedexMainPresenterMockCalls] = []
    var isLoadingCell: Bool = false
    var alertModel: AlertModel?
    
}

extension PokedexMainPresenterMock: PokedexMainPresenterProtocol {
    func didSelectRowAt(_ indexPath: IndexPath) {
        calls.append(.didSelectRowAt)
    }
    
    func shouldPrefetch(at indexPaths: [IndexPath]) {
        calls.append(.shouldPrefetch)
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        calls.append(.isLoadingCell)
        return isLoadingCell
    }
    
    func reloadSections() {
        calls.append(.reloadSections)
    }
    
    func willFetchPokemons() {
        calls.append(.willFetchPokemons)
    }
}

extension PokedexMainPresenterMock: PokedexMainInteractorOutputProtocol {
    
    func onReceivedData(with pokemonBlock: PokemonBlock) {
        calls.append(.onReceivedData)
    }
    
    func onReceivedPokemon(_ pokemons: [Pokemon]) {
        calls.append(.onReceivedPokemon)
    }
    
    func willShowAlert(with alertModel: AlertModel) {
        calls.append(.willShowAlert)
        self.alertModel = alertModel
    }
}
