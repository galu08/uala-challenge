//
//  CityTrie.swift
//  Cities
//
//  Created by Gonzalo Alu on 13/03/2025.
//
import Foundation

/// Node that associated a character with an array of cities that start with that prefix.
class TrieNode {
    var children: [Character: TrieNode] = [:]
    var cities: [City] = []
    var isEndOfWord: Bool = false
}

class CityTrie {
    
    private let root = TrieNode()
    
    /// Insert a city in the tree by going throw all the characters
    func insert(city: City) {
        let key = city.name.lowercased()
        var node = root
        
        for char in key {
            if node.children[char] == nil {
                node.children[char] = TrieNode()
            }
            node = node.children[char]!
        }
        
        node.isEndOfWord = true
        node.cities.append(city) // puede haber más de una ciudad con el mismo nombre
    }
    
    /// Search by the given prefix in the tree and return all the Cities associated.
    func search(prefix: String) -> [City] {
        let key = prefix.lowercased()
        var node = root
        
        for char in key {
            if let nextNode = node.children[char] {
                node = nextNode
            } else {
                return [] // no hay nada con ese prefijo
            }
        }
        return collectAllCities(from: node)
    }
    
    /// Recursive function that search all child cities from a given node. In other words, all the Cities that start with the prefix
    private func collectAllCities(from node: TrieNode) -> [City] {
        var result = [City]()
        
        if node.isEndOfWord {
            result.append(contentsOf: node.cities)
        }
        
        for child in node.children.values {
            result.append(contentsOf: collectAllCities(from: child))
        }
        
        return result
    }
}

