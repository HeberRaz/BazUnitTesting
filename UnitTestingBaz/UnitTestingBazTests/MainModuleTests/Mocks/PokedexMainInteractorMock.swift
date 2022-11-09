//
//  PokedexMainInteractorMock.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import Foundation
@testable import UnitTestingBaz

enum PokedexMainInteractorMockCalls {
    case fetchDetailFromPokemonName
    case fetchPokemonBlock
    case handlePokemonBlockFetch
    case handleFetchedPokemon
    case handleServiceError
}

final class PokedexMainInteractorMock {
    // MARK: - InteractorInput protocol properties
    var presenter: PokedexMainInteractorOutputProtocol?
    var remoteData: PokedexMainRemoteDataInputProtocol?
    
    var nextBlockUrl: String?
    let group: DispatchGroup = DispatchGroup()
    
    // MARK: Properties
    var calls: [PokedexMainInteractorMockCalls] = []
    var error: ServiceError?
    var catchUrl: String?
    
}

extension PokedexMainInteractorMock: PokedexMainInteractorInputProtocol {
    func fetchDetailFrom(pokemonName: String) {
        calls.append(.fetchDetailFromPokemonName)
    }
    
    func fetchPokemonBlock(_ urlString: String?) {
        self.catchUrl = urlString
        calls.append(.fetchPokemonBlock)
    }
}

extension PokedexMainInteractorMock: PokedexRemoteDataOutputProtocol {
    
    func handlePokemonBlockFetch(_ pokemonBlock: PokemonBlock) {
        calls.append(.handlePokemonBlockFetch)
    }
    
    func handleFetchedPokemon(_ pokemonDetail: PokemonDetail) {
        calls.append(.handleFetchedPokemon)
    }
    
    func decodePokemon(data: Data, handler: (Result<PokemonDetail, Error>) -> Void) {
    }
    
    func handleService(error: Error) {
        self.error = error as? ServiceError
        calls.append(.handleServiceError)
    }
}
