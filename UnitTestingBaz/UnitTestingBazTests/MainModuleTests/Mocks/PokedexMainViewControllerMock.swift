//
//  PokedexMainViewControllerMock.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 04/11/22.
//

import UIKit
@testable import UnitTestingBaz

final class PokedexMainViewControllerMock: UIViewController, PokedexMainViewControllerProtocol {
    var presenter: PokedexMainPresenterProtocol?
    var pokemonList: [PokemonCellModel] = []
    
    var calls: [String] = []
    
    func reloadInformation() {
        calls.append(#function)
    }
    
    func fillPokemonList() {
        calls.append(#function)
    } 
}
