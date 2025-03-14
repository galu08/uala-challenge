//
//  City.swift
//  Cities
//
//  Created by Gonzalo Alu on 12/03/2025.
//

class City: CustomStringConvertible, Identifiable, Hashable {
    
    var description: String { name + " " + country}
    
    let country: String
    let name: String
    let id: Int
    let coordinate: Coordinate
    
    init(country: String, name: String, id: Int, coordinate: Coordinate) {
        self.country = country
        self.name = name
        self.id = id
        self.coordinate = coordinate
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Equatable
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
}

class Coordinate {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    // MARK: - Equatable
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
