//
//  MockVenueService.swift
//  NearbyAppTests
//
//  Created by Raj Shekhar on 17/06/24.
//

import Foundation
import CoreLocation
@testable import NearbyApp

class MockLocationManager: LocationManagerProtocol {
    
    var userLocation: CLLocation?
    
    func setUserLocation(lat: Double, lon: Double) {
        userLocation = CLLocation(latitude: lat, longitude: lon)
    }
}

class MockVenueService: VenueServiceProtocol {
    func fetchVenues(lat: Double, lon: Double, range: String, page: Int, itemsPerPage: Int, completion: @escaping (Result<VenuesResponse, Error>) -> Void) {
        // Implement mock data or logic for testing purposes
        let venues = [
            Venue(name: "Venue 1", city: "Bangalore", displayLocation: "Bangalore", address: nil, location: Location(lat: 11.111, lon: 22.222), url: nil),
            Venue(name: "Venue 2", city: "Mumbai", displayLocation: "Mumbai", address: "Address 2", location: Location(lat: 12.345, lon: 67.890), url: "https://venue2.com")
            // Add more mock venues as needed
        ]
        
        let meta = Meta(total: venues.count, page: 1, perPage: itemsPerPage)
        let response = VenuesResponse(venues: venues, meta: meta)
        
        completion(.success(response))
    }
}
