//
//  CitiesStore.swift
//  Cities
//
//  Created by Gonzalo Alu on 11/03/2025.
//
import Foundation

protocol CitiesAPI {
    ///  Fetch all cities from BE and return an array for CityDTO
    func fetchCities() async throws -> [CityDTO]
}

class CityStore: CitiesAPI {
    
    private let urlString = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
    
    func fetchCities() async throws -> [CityDTO] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let city = try JSONDecoder().decode([CityDTO].self, from: data)
        return city
    }
}
