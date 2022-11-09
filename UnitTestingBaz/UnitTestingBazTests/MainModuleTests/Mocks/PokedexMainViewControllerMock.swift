//
//  PokedexMainViewControllerMock.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 04/11/22.
//

import UIKit
@testable import UnitTestingBaz

enum PokedexMainViewControllerMockCalls {
    case reloadInformation
    case fillPokemonList
}

final class PokedexMainViewControllerMock: UIViewController, PokedexMainViewControllerProtocol {
    func showLoader() {
    }
    
    func hideLoader() {
    }
    
    var presenter: PokedexMainPresenterProtocol?
    var pokemonList: [PokemonCellModel] = []
    
    var calls: [PokedexMainViewControllerMockCalls] = []
    
    func reloadInformation() {
        calls.append(.reloadInformation)
    }
    
    func fillPokemonList() {
        calls.append(.fillPokemonList)
    } 
}
