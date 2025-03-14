//
//  CityBuilder.swift
//  Cities
//
//  Created by Gonzalo Alu on 14/03/2025.
//

protocol CityBuilder {
    /// Build City object from DTO.
    /// Note: Just to split the model from BE with the model used in the App.
    func build(from dto: CityDTO) -> City
}

class CityBuilderImpl: CityBuilder {
    
    func build(from dto: CityDTO) -> City {
        let coordinate = Coordinate(latitude: dto.coord.lat, longitude: dto.coord.lon)
        return City(country: dto.country, name: dto.name, id: dto.id, coordinate: coordinate)
    }
}
