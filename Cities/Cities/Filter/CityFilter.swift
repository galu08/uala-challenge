//
//  CityFilter.swift
//  Cities
//
//  Created by Gonzalo Alu on 14/03/2025.
//

import Foundation

protocol CityFilter {
    /// Pre-process an array of cities into a Prefix Tree to make quick searches.
    func process(cities: [City]) async
    
    /// Return an array of City that has the given prefix.
    func filter(by prefix: String) -> [City]
}

class CityFilterImpl: CityFilter {
    
    private var cityTrie: CityTrie = CityTrie()
    
    func process(cities: [City]) async {
        // Preprocess all cities. Avoid using main thread for this.
        await Task.detached(priority: .utility) { [weak self] in
            guard let self = self else { return }
            for city in cities {
                self.cityTrie.insert(city: city)
            }
        }.value
    }
    
    
    func filter(by prefix: String) -> [City] {
        let start = Date()
        let result = cityTrie.search(prefix: prefix)
        let end = Date()
        let timeInterval = end.timeIntervalSince(start)
        print(String(format: "Search took %.3f seconds", timeInterval))
        
        return result
    }
}
