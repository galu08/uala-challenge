//
//  CitiesViewModel.swift
//  Cities
//
//  Created by Gonzalo Alu on 12/03/2025.
//
import Foundation
import Combine

@MainActor
class CitiesViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var selectedCity: City?
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var filteredCities: [City] = []

    // Keep a reference to the original sorted list
    private var cities: [City] = []
    private let cityService: CityService
    private let cityFilter: CityFilter
    
    private var cancellables = Set<AnyCancellable>()
    
    init(cityService: CityService = CityServiceImpl(),
         cityFilter: CityFilter = CityFilterImpl()) {
        self.cityService = cityService
        self.cityFilter = cityFilter
        setupSearchText()
    }
    
    // Perform a filter every time the user add/remove a character from search field.
    // Improvement: We can add a debounce here.
    private func setupSearchText() {
        $searchText
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }
                self.performFilter(text: text)
            }
            .store(in: &cancellables)
    }
    
    /// Perform the filter or return the original list if the text is empty
    private func performFilter(text: String) {
        // Avoid searching with empty text. Just show the list.
        if text.isEmpty {
            filteredCities = cities
        } else {
            let start = Date()
            filteredCities = cityFilter.filter(by: text)
            let timeInterval = Date().timeIntervalSince(start)
            print("Search took \(String(format: "%.4f", timeInterval)) seconds")
        }
    }
    
    // Load and preprocess cities for filter.
    func loadCities() async {
        isLoading = true
        errorMessage = nil
        do {
            // Fetch Cities
            let fetchedCities = try await cityService.fetchCities()
            
            // Save original list
            self.cities = fetchedCities
            
            // Display origal list
            self.filteredCities = fetchedCities
            
            // Process cities to allow faster seach
            await cityFilter.process(cities: fetchedCities)
            
        } catch {
            self.errorMessage = "Failed to load cities: error.localizedDescription"
        }
        isLoading = false
    }

    func toggleFavorite(for city: City) {
        print("Favorite \(city.description)")
    }
}
