//
//  VenueModel.swift
//  NearbyApp
//
//  Created by Raj Shekhar on 17/06/24.
//

import Foundation

struct Venue: Codable {
    let name: String
    let city: String
    let displayLocation: String
    let address: String?
    let location: Location
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name
        case city
        case displayLocation = "display_location"
        case address
        case location
        case url
    }
}

struct Location: Codable {
    let lat: Double
    let lon: Double
}

struct VenuesResponse: Codable {
    let venues: [Venue]
    let meta: Meta
}

struct Meta: Codable {
    let total: Int
    let page: Int
    let perPage: Int

    enum CodingKeys: String, CodingKey {
        case total
        case page
        case perPage = "per_page"
    }
}
