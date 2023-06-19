//
//  ApiService.swift
//  Weather
//
//  Created by Kate on 28.05.2023.
//

import Foundation

enum ApiError: Error {
    case badUrl
}

struct ApiService {
    static let shared = ApiService()

    let baseUrl = "https://api.openweathermap.org"
    let apiKey = "ba4f434450c83f44645470b61ee14800"

    func getWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        var urlComponens = URLComponents(string: "\(baseUrl)/data/2.5/weather")

        urlComponens?.queryItems = [
            .init(name: "lat", value: String(lat)),
            .init(name: "lon", value: String(lon)),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: "metric")
        ]

        guard let url = urlComponens?.url else { throw ApiError.badUrl }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)

        let response = try JSONDecoder().decode(WeatherResponse.self, from: data)

        return response
    }

    func getCoordinates(query: String) async throws -> GeocodingResponse {
        var urlComponens = URLComponents(string: "\(baseUrl)/geo/1.0/direct")

        urlComponens?.queryItems = [
            .init(name: "q", value: query),
            .init(name: "appid", value: apiKey),
            .init(name: "limit", value: "5")
        ]

        guard let url = urlComponens?.url else { throw ApiError.badUrl }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)

        let response = try JSONDecoder().decode(GeocodingResponse.self, from: data)

        return response
    }
}
