//
//  CitiesTests.swift
//  CitiesTests
//
//  Created by Gonzalo Alu on 14/03/2025.
//

import Testing
@testable import Cities

struct CityFilterImplTests {
    
    /* Test for document clarification section
     
     We define a prefix string as: a substring that matches the initial characters of the
     target string. For instance, assume the following entries:
     
     Alabama, US
     Albuquerque, US
     Anaheim, US
     Arizona, US
     Sydney, AU
     
     If the given prefix is "A", all cities but Sydney should appear.
     Contrariwise, if the given prefix is "s", the only result should be "Sydney, AU".
     If the given prefix is "Al", "Alabama, US" and "Albuquerque, US" are the only results.
     If the prefix given is "Alb" then the only result is "Albuquerque, US"
     */

    @Test func filter_byFirstCharacter_returnValues() async throws {
        let sut = CityFilterImpl()
        let coordinate = Coordinate(latitude: 0, longitude: 0)
        
        let cities = [
            City(country: "US", name: "Alabama", id: 1, coordinate: coordinate),
            City(country: "US", name: "Albuquerque", id: 1, coordinate: coordinate),
            City(country: "US", name: "Anaheim", id: 1, coordinate: coordinate),
            City(country: "US", name: "Arizona", id: 1, coordinate: coordinate),
            City(country: "AU", name: "Sydney", id: 1, coordinate: coordinate)
            ]
        await sut.process(cities: cities)
        
        // If the given prefix is "A" all cities but Sydney should appear
        let result = sut.filter(by: "A")
        #expect(result.contains(where: { $0.name == "Sydney"}) == false, "all cities but Sydney should appear")
        #expect(result.count == 4)
        #expect(result.allSatisfy({ $0.name.first == "A"}) == true, "First letter from all results is A")
        
        // Contrariwise, if the given prefix is "s", the only result should be "Sydney, AU"
        let result2 = sut.filter(by: "S")
        #expect(result2.count == 1)
        #expect(result2[0].name == "Sydney", "only result should be Sydney, AU")
    }
    
    // If the given prefix is "Al", "Alabama, US" and "Albuquerque, US" are the only results
    @Test func filter_byTwoCharacters_returnValues() async throws {
        let sut = CityFilterImpl()
        let coordinate = Coordinate(latitude: 0, longitude: 0)
        
        let cities = [
            City(country: "US", name: "Alabama", id: 1, coordinate: coordinate),
            City(country: "US", name: "Albuquerque", id: 1, coordinate: coordinate),
            City(country: "US", name: "Anaheim", id: 1, coordinate: coordinate),
            City(country: "US", name: "Arizona", id: 1, coordinate: coordinate),
            City(country: "AU", name: "Sydney", id: 1, coordinate: coordinate)
            ]
        
        await sut.process(cities: cities)
        
        let result = sut.filter(by: "Al")
        
        #expect(result.contains(where: { $0.name == "Albuquerque"}) == true, "Only Albuquerque is valid")
        #expect(result.count == 2)
    }
    
    
    // If the prefix given is "Alb" then the only result is "Albuquerque, US"
    @Test func filter_byPrefix_returnValues() async throws {
        let sut = CityFilterImpl()
        let coordinate = Coordinate(latitude: 0, longitude: 0)
        
        let cities = [
            City(country: "US", name: "Alabama", id: 1, coordinate: coordinate),
            City(country: "US", name: "Albuquerque", id: 1, coordinate: coordinate),
            City(country: "US", name: "Anaheim", id: 1, coordinate: coordinate),
            City(country: "US", name: "Arizona", id: 1, coordinate: coordinate),
            City(country: "AU", name: "Sydney", id: 1, coordinate: coordinate)
            ]
        
        await sut.process(cities: cities)
        
        let result = sut.filter(by: "Alb")
        
        #expect(result.contains(where: { $0.name == "Albuquerque"}) == true, "Only Albuquerque is valid")
        #expect(result.count == 1)
    }
    
    @Test func filter_byPrefix_doNotFindResults() async throws {
        let sut = CityFilterImpl()
        let coordinate = Coordinate(latitude: 0, longitude: 0)
        let cities = [City(country: "US", name: "Alabama", id: 1, coordinate: coordinate)]
        await sut.process(cities: cities)
        
        let result = sut.filter(by: "B")
        
        #expect(result.isEmpty)
    }
    
    @Test func filter_process_keepOriginalOrder() async throws {
        let sut = CityFilterImpl()
        let coordinate = Coordinate(latitude: 0, longitude: 0)
        
        // Unsorted
        let cities_unsorted = [
            City(country: "US", name: "Arizona", id: 2, coordinate: coordinate),
            City(country: "US", name: "Alabama", id: 1, coordinate: coordinate)
            ]
        
        await sut.process(cities: cities_unsorted)
        
        let result_unsorted = sut.filter(by: "A")
        
        #expect(result_unsorted.count == 2)
        #expect(result_unsorted[0].name == "Arizona", "First must be Alabama")
        #expect(result_unsorted[1].name == "Alabama", "Seconds must be Alabama")
    }
}
