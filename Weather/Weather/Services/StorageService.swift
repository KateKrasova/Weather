//
//  StorageService.swift
//  Weather
//
//  Created by Kate on 20.06.2023.
//

import Foundation

public struct StorageService {
    // MARK: - Shared

    public static let shared = StorageService()

    // MARK: - Private Props

    private let userDefaults = UserDefaults.standard
}

// MARK: - Public Methods

public extension StorageService {
    enum Keys: String {
        case lat
        case lon
    }

    func saveCords(value: (Double, Double)) {
        userDefaults.set(value.0, forKey: Keys.lat.rawValue)
        userDefaults.set(value.1, forKey: Keys.lon.rawValue)
    }

    func fetchCords() -> (Double, Double)? {
        let lat = userDefaults.double(forKey: Keys.lat.rawValue)
        let lon = userDefaults.double(forKey: Keys.lon.rawValue)

        guard lat != 0 || lon != 0 else {return nil}

        return (lat, lon)
    }
}
