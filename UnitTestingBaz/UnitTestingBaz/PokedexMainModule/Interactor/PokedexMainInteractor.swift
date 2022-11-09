//
//  TransverseSearcherInteractor.swift
//  UnitTestingBaz
//
//  Created by Heber Raziel Alvarez Ruedas on 31/10/22.
//

import Foundation

final class PokedexMainInteractor {
    
    // MARK: - Protocol properties
    
    weak var presenter: PokedexMainInteractorOutputProtocol?
    var remoteData: PokedexMainRemoteDataInputProtocol?
    var nextBlockUrl: String?
    var pokemonList: [Pokemon] = []
    let group: DispatchGroup = DispatchGroup()
}

extension PokedexMainInteractor: PokedexMainInteractorInputProtocol {
    func fetchPokemonBlock(_ urlString: String?) {
        remoteData?.requestPokemonBlock(urlString)
    }
    
    func fetchDetailFrom(pokemonName: String) {
        group.enter()
        remoteData?.requestPokemon(pokemonName)
    }
    
    private func getImageDataFrom(urlString: String) -> Data? {
        guard let imageUrl: URL = URL(string: urlString) else {
            return nil
        }
        do {
            let imageData: Data = try Data(contentsOf: imageUrl)
            return imageData
        } catch {
            return nil
        }
    }
}

extension PokedexMainInteractor: PokedexRemoteDataOutputProtocol {
    
    func handlePokemonBlockFetch(_ pokemonBlock: PokemonBlock) {
        self.nextBlockUrl = pokemonBlock.next
        self.presenter?.isFetchInProgress = false
        self.presenter?.onReceivedData(with: pokemonBlock)
        group.notify(queue: DispatchQueue.main) {
            self.presenter?.onReceivedPokemon(self.pokemonList)
            self.pokemonList = []
        }
    }

    func handleFetchedPokemon(_ pokemonDetail: PokemonDetail) {
        guard let imageData: Data = self.getImageDataFrom(urlString: pokemonDetail.sprites.frontDefault)
        else { return }
        self.pokemonList.append(Pokemon(from: pokemonDetail, imageData: imageData))
        group.leave()
    }

    func handleService(error: Error) {
        guard let fetchedError: ServiceError = error as? ServiceError else { return }
        let alertModel: AlertModel = AlertModel(serviceError: fetchedError)
        
        self.presenter?.willShowAlert(with: alertModel)
    }
}
