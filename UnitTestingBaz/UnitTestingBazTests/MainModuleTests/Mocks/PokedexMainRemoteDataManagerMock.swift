//
//  PokedexMainRemoteDataManagerMock.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import Foundation
@testable import UnitTestingBaz

enum PokedexMainRemoteDataManagerMockCalls {
    case requestPokemonBlock
    case requestPokemon
}


final class PokedexMainRemoteDataManagerMock: PokedexMainRemoteDataInputProtocol {
    
    // MARK: - Protocol properties
    var interactor: PokedexRemoteDataOutputProtocol?
    
    // MARK: - Class properties
    var calls: [PokedexMainRemoteDataManagerMockCalls] = []
    var urlString: String?
    var pokemonName: String?
    
    // MARK: - Protocol methods
    func requestPokemonBlock(_ urlString: String?) {
        calls.append(.requestPokemonBlock)
        self.urlString = urlString
    }
    
    func requestPokemon(_ name: String) {
        calls.append(.requestPokemon)
        self.pokemonName = name
    }
}
