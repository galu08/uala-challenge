//
//  CityListView.swift
//  Cities
//
//  Created by Gonzalo Alu on 12/03/2025.
//
import SwiftUI

/// View that shows a list of Cities allowing to fitler by prefix.
struct CitiesListView: View {
    
    @ObservedObject var viewModel: CitiesViewModel
    
    var body: some View {
        List(viewModel.filteredCities, id: \.id, selection: $viewModel.selectedCity) { city in
            NavigationLink(destination: CityDetailView(city: city)) {
                CityRowView(city: city) {
                    viewModel.toggleFavorite(for: city)
                }
            }
        }
        .id(UUID()) // Refresh list. not ideal solution but needed to show big dataset.
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .listStyle(.plain)
        .background(Color(.systemBackground)) 
    }
}

/// View for each City Row
struct CityRowView: View {
    let city: City
    let onFavoriteTapped: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(city.name)
                    .font(.headline)
                Text(city.country)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                onFavoriteTapped()
            }) {
                let icon: String = "heart.fill" // TODO: city.isFavorite ? "heart.fill" : "heart"
                let color: Color = .gray // TODO: city.isFavorite ? .red : .gray
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
