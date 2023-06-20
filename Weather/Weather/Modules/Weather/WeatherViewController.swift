//
//  WeatherViewController.swift
//  Weather
//
//  Created by Kate on 28.05.2023.
//

import UIKit

final class WeatherViewController: UIViewController {
    // MARK: - Private Props

    private let moduleView = WeatherView()

    // MARK: - LifeCycle

    override func loadView() {
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let coord = StorageService.shared.fetchCords() else {return}
        print(coord)
        fetchData(lat: coord.0, lon: coord.1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
}
// MARK: - Private Methods

private extension WeatherViewController {
    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(findPressed)
        )

        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    @objc
    func findPressed() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)

        vc.updateCoordinates = { [weak self] lat, lon in
            self?.fetchData(lat: lat, lon: lon)
        }
    }

    func fetchData(lat: Double, lon: Double) {
        Task {
            do {
                let weather = try await ApiService.shared.getWeather(lat: lat, lon: lon)
                guard
                    let date = weather.date,
                    let name = weather.name,
                    let country = weather.sys?.country,
                    let temp = weather.main?.temp,
                    let mainWeather = weather.weather?.first?.main,
                    let wind = weather.wind?.speed,
                    let visibility = weather.visibility,
                    let humidity = weather.main?.humidity,
                    let airPressure = weather.main?.pressure
                else {
                    return
                }

                moduleView.render(
                    .init(
                        date: date,
                        city: name,
                        country: country,
                        temperature: temp,
                        mainWearher: mainWeather,
                        wind: wind,
                        visibilit: visibility,
                        humidity: humidity,
                        airPressure: airPressure
                    )
                )
            } catch {
                print(error)
            }
        }
    }
}
