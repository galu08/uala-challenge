//
//  CityDTO.swift
//  Cities
//
//  Created by Gonzalo Alu on 14/03/2025.
//

/// DTO for City
struct CityDTO: Decodable {
    let country: String
    let name: String
    let id: Int
    let coord: CoordinateDTO
    
    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }
}

/// DTO for Coordinate
struct CoordinateDTO: Decodable {
    let lon: Double
    let lat: Double
}
