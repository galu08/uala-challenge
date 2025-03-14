//
//  CityService.swift
//  Cities
//
//  Created by Gonzalo Alu on 12/03/2025.
//

protocol CityService {
    /// Fetch from cache if possible or BE and return an ordered array of City elements
    func fetchCities() async throws -> [City]
}

class CityServiceImpl: CityService {
    
    private let store: CitiesAPI
    private let builder: CityBuilder
    
    private var citiesCache: [City] = []
    
    init(store: CitiesAPI = CityStore(), builder: CityBuilder = CityBuilderImpl()) {
        self.store = store
        self.builder = builder
    }
    
    func fetchCities() async throws -> [City] {
        if citiesCache.isEmpty {
            let citiesDTO =  await (try? store.fetchCities()) ?? []
            let cities = citiesDTO.map({ builder.build(from: $0) })
            
            // Sort in a background task
            let sortedCities = await Task.detached(priority: .utility) {
                // Sorting logic could be injected as dependency using SortCoparator
                return cities.sorted(by: { $0.description < $1.description })
            }.value
            
            // Store sorted cities in in-memory cache
            citiesCache = sortedCities
            return sortedCities
            
        } else {
            return citiesCache
        }
    }
}
