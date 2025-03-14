//
//  CityDetailView.swift
//  Cities
//
//  Created by Gonzalo Alu on 12/03/2025.
//
import SwiftUI
import MapKit

/// View that shows the given city centered in a map.
struct CityDetailView: View {
    private let city: City
    
    @State private var position: MapCameraPosition

    init(city: City) {
        self.city = city
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: city.coordinate.latitude, longitude: city.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        ))
    }

    var body: some View {
            Map(position: $position) {
                Annotation(city.name, coordinate: CLLocationCoordinate2D(latitude: city.coordinate.latitude, longitude: city.coordinate.longitude)) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                        Text("📍")
                            .font(.system(size: 14))
                    }
                }
            }
            .navigationTitle(city.name)
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.all)
        }
}
