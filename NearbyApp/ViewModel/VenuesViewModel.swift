//
//  VenuesViewModel.swift
//  NearbyApp
//
//  Created by Raj Shekhar on 17/06/24.
//

import Foundation
import CoreLocation

class VenuesViewModel {
    private let venueService: VenueServiceProtocol
    private let locationManager: LocationManagerProtocol
    private var currentPage = 1
    private var isLoading = false
    private var cacheKey = "cachedVenues"
    private let itemsPerPage = 10
    
    var venues: [Venue] = []
    var filteredVenues: [Venue] = []
    var updateHandler: (() -> Void)?
    var errorHandler: ((String) -> Void)?
    var filterDistance: Double = 5.0 {
        didSet {
            filterVenuesByDistance()
        }
    }
    
    func setUserLocation(lat: Double, lon: Double) {
        locationManager.setUserLocation(lat: lat, lon: lon)
    }
    init(venueService: VenueServiceProtocol = VenueService(), locationManager: LocationManagerProtocol = LocationManager()) {
        self.venueService = venueService
        self.locationManager = locationManager
        loadCachedVenues()
    }
    
    func fetchVenues() {
        guard let userLocation = locationManager.userLocation, !isLoading else { return }
        isLoading = true
        let range = "\(Int(filterDistance))mi"  // Use miles for the API range parameter
        
        venueService.fetchVenues(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude, range: range, page: currentPage, itemsPerPage: itemsPerPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.venues.append(contentsOf: response.venues)
                self.currentPage += 1
                self.cacheVenues()
                self.filterVenuesByDistance()
                self.updateHandler?()
            case .failure(let error):
                self.errorHandler?(error.localizedDescription)
            }
        }
    }
    
    private func filterVenuesByDistance() {
        guard let userLocation = locationManager.userLocation else { return }
        
        filteredVenues = venues.filter { venue in
            let venueLocation = CLLocation(latitude: venue.location.lat, longitude: venue.location.lon)
            let distance = userLocation.distance(from: venueLocation) / 1000.0 // Convert to kilometers
            return distance <= filterDistance
        }
        
        DispatchQueue.main.async {
            self.updateHandler?()
        }
    }
    
    private func cacheVenues() {
        if let data = try? JSONEncoder().encode(venues) {
            UserDefaults.standard.setValue(data, forKey: cacheKey)
        }
    }
    
    private func loadCachedVenues() {
        if let data = UserDefaults.standard.data(forKey: cacheKey),
           let cachedVenues = try? JSONDecoder().decode([Venue].self, from: data) {
            venues = cachedVenues
            filterVenuesByDistance()
            updateHandler?()
        }
    }
    
    func resetPagination() {
        venues.removeAll()
        currentPage = 1
        fetchVenues()
    }
    
    func searchVenuesLocally(by name: String) {
        if name.isEmpty {
            filteredVenues = venues
        } else {
            filteredVenues = venues.filter { $0.name.lowercased().contains(name.lowercased()) }
        }
        updateHandler?()
    }
}
