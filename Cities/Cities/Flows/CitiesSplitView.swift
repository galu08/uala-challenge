//
//  ContentView.swift
//  Cities
//
//  Created by Gonzalo Alu on 11/03/2025.
//

import SwiftUI

// Main view that display a NavigationSplitView with a master / detail configuration
struct CitiesSplitView: View {
    @StateObject private var viewModel = CitiesViewModel()

    var body: some View {
        NavigationSplitView {
            
            if viewModel.isLoading {
                ProgressView("Loading Cities...")
                
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Retry") {
                        Task { await viewModel.loadCities() }
                    }
                    .padding()
                }
            } else {
                CitiesListView(viewModel: viewModel)
                .navigationDestination(for: City.self) { city in
                    CityDetailView(city: city)
                }
                .navigationTitle("Cities")
            }
            
        } detail: {
            if let city = viewModel.selectedCity {
                CityDetailView(city: city)
            } else {
                Text("Select a city")
                    .foregroundColor(.gray)
            }
        }
        .task {
            await viewModel.loadCities()
        }
    }
}
