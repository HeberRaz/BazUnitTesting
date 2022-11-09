//
//  TransverseSearcherPresenter.swift
//  UnitTestingBaz
//
//  Created by Heber Raziel Alvarez Ruedas on 31/10/22.
//

import Foundation

final class PokedexMainPresenter {
    
    // MARK: - Protocol properties
    
    weak var view: PokedexMainViewControllerProtocol?
    var interactor: PokedexMainInteractorInputProtocol?
    var router: PokedexMainRouterProtocol?
    
    var model: [Pokemon] = []
    var isFetchInProgress: Bool = false
    var totalPokemonCount: Int?
    
    // MARK: - Private properties
    
    private typealias Constants = PokedexMainConstants
}

extension PokedexMainPresenter: PokedexMainPresenterProtocol {
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        let pokemonName: String = view?.pokemonList[indexPath.row].name ?? ""
        router?.presentPokemonDetail(named: pokemonName)
    }
    
    func reloadSections() {
        view?.reloadInformation()
    }
    
    func willFetchPokemons() {
        interactor?.fetchPokemonBlock()
    }
    
    func shouldPrefetch(at indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            guard !isFetchInProgress else { return }
            isFetchInProgress = true
            interactor?.fetchPokemonBlock(interactor?.nextBlockUrl ?? "")
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        let currentCount: Int = view!.pokemonList.count
        let shouldFetchNextPokemonBlock: Bool = indexPath.row >= currentCount
        return shouldFetchNextPokemonBlock
    }
}

extension PokedexMainPresenter: PokedexMainInteractorOutputProtocol {
    
    func onReceivedData(with pokemonBlock: PokemonBlock) {
        let pokemonResults: [PokemonBlockResult] = pokemonBlock.results
        self.totalPokemonCount = pokemonBlock.count
        for pokemon in pokemonResults {
            let pokemonName: String = pokemon.name
            interactor?.fetchDetailFrom(pokemonName: pokemonName)
        }
    }
    
    func onReceivedPokemon(_ pokemon: [Pokemon]) {
        var pokemonList = pokemon
        pokemonList = pokemonList.sorted { previous, next in
            return previous.id < next.id
        }
        self.model = pokemonList
        view?.fillPokemonList()
    }
    
    func willShowAlert(with alertModel: AlertModel) {
        router?.showAlert(with: alertModel) {
            debugPrint("Algo puede hacerse aquí")
        }
    }
}
