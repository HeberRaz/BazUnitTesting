//
//  TransverseSearcherRemoteDataManager.swift
//  UnitTestingBaz
//
//  Created by Heber Raziel Alvarez Ruedas on 31/10/22.
//

import Foundation

final class PokedexMainRemoteDataManager {
    
    // MARK: - Protocol properties
    weak var interactor: PokedexRemoteDataOutputProtocol?
    
    // MARK: - Private properties
    let service: ServiceApiProtocol
    
    // MARK: - Intializer
    init(service: ServiceApiProtocol) {
        self.service = service
    }
}

extension PokedexMainRemoteDataManager: PokedexMainRemoteDataInputProtocol {
    
    func requestPokemonBlock(_ urlString: String?, handler: @escaping (Result<PokemonBlock, Error>) -> Void) {
        service.get(Endpoint.next(urlString: urlString ?? Endpoint.baseURL)) { [weak self] (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                self?.interactor?.decodePokemonBlock(data: data, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func requestPokemon(_ name: String, handler: @escaping (Result<PokemonDetail, Error>) -> Void) {
        service.get(Endpoint.pokemon(nameOrId: name)) { [weak self] (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                self?.interactor?.decodePokemon(data: data, handler: handler)
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
