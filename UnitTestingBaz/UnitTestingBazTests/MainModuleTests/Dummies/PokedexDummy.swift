//
//  PokedexDummy.swift
//  UnitTestingBazTests
//
//  Created by Heber Raziel Alvarez Ruedas on 07/11/22.
//

import Foundation

final class PokedexDummy {
    private func getDataFrom(json file: String) -> Data {
        guard let path = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") else { fatalError("Couldn't find \(file).json file") }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        return data
    }
}

extension PokedexDummy {
    var blockData: Data { getDataFrom(json: "pokemonBlockFake") }
    var detailData: Data { getDataFrom(json: "pokemonDetailFake") }
    var jsonMismatch: Data { getDataFrom(json: "mismatched") }
}
