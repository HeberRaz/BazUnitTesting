//
//  PokedexProtocols.swift
//  UnitTestingBaz
//
//  Created by Heber Raziel Alvarez Ruedas on 31/10/22.
//

import Foundation
import UIKit

// MARK: - VIPER protocols

// Presenter > Router
protocol PokedexMainRouterProtocol {
    var view: PokedexMainViewControllerProtocol? { get set }
    var interactor: (PokedexMainInteractorInputProtocol & PokedexRemoteDataOutputProtocol)? { get set }
    var presenter: (PokedexMainPresenterProtocol & PokedexMainInteractorOutputProtocol)? { get set }
    var router: PokedexMainRouterProtocol? { get set }
    var remoteData: PokedexMainRemoteDataInputProtocol? { get set }
    
    func createPokedexMainModule() -> UINavigationController
    func presentPokemonDetail(named pokemonName: String)
}

// View > Presenter
protocol PokedexMainViewControllerProtocol: AnyObject {
    var presenter: PokedexMainPresenterProtocol? { get set }
    
    var pokemonList: [PokemonCellModel] { get set }
    
    func reloadInformation()
    func fillPokemonList()
}

// Presenter > View
protocol PokedexMainPresenterProtocol: AnyObject {
    var view: PokedexMainViewControllerProtocol? { get set }
    var router: PokedexMainRouterProtocol? { get set }
    var model: [Pokemon] { get set }
    
    var totalPokemonCount: Int? { get set }
    
    func didSelectRowAt(_ indexPath: IndexPath)
    func shouldPrefetch(at indexPaths: [IndexPath])
    func isLoadingCell(for indexPath: IndexPath) -> Bool
    
    func reloadSections()
    func willFetchPokemons()
}

// Interactor > Presenter
protocol PokedexMainInteractorInputProtocol {
    var presenter: PokedexMainInteractorOutputProtocol? { get set }
    var remoteData: PokedexMainRemoteDataInputProtocol? { get set }
    
    func fetchPokemonBlock(_ urlString: String?)
    func fetchDetailFrom(pokemonName: String)
}

extension PokedexMainInteractorInputProtocol {
    func fetchPokemonBlock(_ urlString: String? = nil) {
        fetchPokemonBlock(nil)
    }
}

// Presenter > Interactor
protocol PokedexMainInteractorOutputProtocol: AnyObject {
    var interactor: PokedexMainInteractorInputProtocol? { get set }
    
    var isFetchInProgress: Bool { get set }
    
    func onReceivedData(with pokemonBlock: PokemonBlock)
    func onReceivedPokemon(_ pokemons: Pokemon)
}

// Interactor > RemoteData
protocol PokedexMainRemoteDataInputProtocol {
    var interactor: PokedexRemoteDataOutputProtocol? { get set }

    /// This method wil request for a block of pokemons. The number of pokemons retrieved in each block depends entirly on
    /// the url used as a parameter.
    /// - Parameters:
    ///   - urlString: The url which returns the block of pokemons and the next url which contains the next block of pokemons
    ///   - handler: This callback will handle success or failure response from service
    func requestPokemonBlock(_ urlString: String?, handler: @escaping (Result<PokemonBlock, Error>) -> Void)
    func requestPokemon(_ name: String, handler: @escaping (Result<PokemonDetail, Error>) -> Void)
}

// RemoteData > Interactor
protocol PokedexRemoteDataOutputProtocol: AnyObject {
    func decodePokemonBlock(data: Data, handler: (Result<PokemonBlock, Error>) -> Void)
    func decodePokemon(data: Data, handler: (Result<PokemonDetail, Error>) -> Void)
    func handleService(error: NSError)
}
