//
//  VenueService.swift
//  NearbyApp
//
//  Created by Raj Shekhar on 24/05/24.
//

import Foundation
import CoreLocation

protocol VenueServiceProtocol {
    func fetchVenues(lat: Double, lon: Double, range: String, page: Int, itemsPerPage: Int, completion: @escaping (Result<VenuesResponse, Error>) -> Void)
}

protocol LocationManagerProtocol {
    func setUserLocation(lat: Double, lon: Double)
    var userLocation: CLLocation? { get }
}

class LocationManager: LocationManagerProtocol {
    private var _userLocation: CLLocation?
    
    var userLocation: CLLocation? {
        return _userLocation
    }
    
    func setUserLocation(lat: Double, lon: Double) {
        _userLocation = CLLocation(latitude: lat, longitude: lon)
    }
}

class VenueService: VenueServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let clientId = "Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5"
    private let baseURL = "https://api.seatgeek.com/2/venues"
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchVenues(lat: Double, lon: Double, range: String, page: Int, itemsPerPage: Int, completion: @escaping (Result<VenuesResponse, Error>) -> Void) {
        let urlString = "\(baseURL)?per_page=\(itemsPerPage)&page=\(page)&client_id=\(clientId)&lat=\(lat)&lon=\(lon)&range=\(range)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        networkManager.makeRequest(url: url, completion: completion)
    }
}

