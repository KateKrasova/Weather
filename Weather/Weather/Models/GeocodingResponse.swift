//
//  GeocodingResponce.swift
//  Weather
//
//  Created by Kate on 12.06.2023.
//

import Foundation
// swiftlint:disable all

// MARK: - GeocodingResponseElement
public struct GeocodingResponseElement: Codable {
    public let name: String?
    public let lat: Double?
    public let lon: Double?
    public let country: String?
    public let state: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case lat = "lat"
        case lon = "lon"
        case country = "country"
        case state = "state"
    }

    public init(name: String?, lat: Double?, lon: Double?, country: String?, state: String?) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.country = country
        self.state = state
    }
}

public typealias GeocodingResponse = [GeocodingResponseElement]
