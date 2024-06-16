//
//  VenuesViewModelTests.swift
//  NearbyAppTests
//
//  Created by Raj Shekhar on 17/06/24.
//

import Foundation
import XCTest
@testable import NearbyApp

class VenuesViewModelTests: XCTestCase {
    
    var viewModel: VenuesViewModel!
    var mockVenueService: MockVenueService!
    var mockLocationManager: MockLocationManager!
    
    override func setUp() {
        super.setUp()
        mockVenueService = MockVenueService()
        mockLocationManager = MockLocationManager()
        viewModel = VenuesViewModel(venueService: mockVenueService, locationManager: mockLocationManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockVenueService = nil
        mockLocationManager = nil
        super.tearDown()
    }
    
    func testFetchVenues() {
        // Set up initial user location
        mockLocationManager.setUserLocation(lat: 12.9569, lon: 77.7015)
        
        // Fetch venues
        viewModel.fetchVenues()
        
        // Verify
        XCTAssertEqual(viewModel.venues.count, 2) // Assuming MockVenueService returns 2 venues
        XCTAssertEqual(viewModel.filteredVenues.count, 2) // Initially, filteredVenues should match venues
        
        // Further assertions based on your specific requirements
    }
    
    func testFilterVenuesByDistance() {
        // Set up initial user location
        mockLocationManager.setUserLocation(lat: 12.9569, lon: 77.7015)
        
        // Fetch venues (assuming this triggers filterVenuesByDistance as well)
        viewModel.fetchVenues()
        
        // Simulate changing filter distance
        viewModel.filterDistance = 10.0
        
        // Verify
        XCTAssertEqual(viewModel.filteredVenues.count, 1) // Assuming one venue is within 10 km radius
        
        // Further assertions based on your specific requirements
    }
    
    func testSearchVenuesLocally() {
        // Set up initial user location
        mockLocationManager.setUserLocation(lat: 12.9569, lon: 77.7015)
        
        // Fetch venues (assuming this triggers filterVenuesByDistance as well)
        viewModel.fetchVenues()
        
        // Search locally by venue name
        viewModel.searchVenuesLocally(by: "Venue 1")
        
        // Verify
        XCTAssertEqual(viewModel.filteredVenues.count, 1) // Assuming there's only one venue with "Venue 1"
        
        // Further assertions based on your specific requirements
    }
    
    // Additional test cases can be added for edge cases, error handling, etc.
}
