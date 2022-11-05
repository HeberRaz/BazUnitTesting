//
//  PokedexMainEntity.swift
//  UnitTestingBaz
//
//  Created by Heber Raziel Alvarez Ruedas on 31/10/22.
//

import UIKit

protocol CustomCellViewData {
    var reuseIdentifier: String { get }
}

struct PokemonCellModel: CustomCellViewData {
    var reuseIdentifier: String = "PokemonCell"
    let id: Int
    let name: String?
    let icon: UIImage?
    
    init(from pokemon: Pokemon) {
        self.id = pokemon.id
        self.name = pokemon.name.capitalized
        self.icon = UIImage(data: pokemon.frontImageData)
    }
}

// MARK: - Pokeomon Block

struct PokemonBlock: Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonBlockResult]?
}

// MARK: - Pokemon Result

struct PokemonBlockResult: Decodable {
    let name: String?
    let url: String?
}

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let sprites: PokemonSprites
}

struct PokemonSprites: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct Pokemon {
    let id: Int
    let name: String
    let frontImageData: Data
    
    init(from detail: PokemonDetail, imageData: Data) {
        self.id = detail.id
        self.name = detail.name
        self.frontImageData = imageData
    }
}
