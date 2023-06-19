//
//  WeatherViewController.swift
//  Weather
//
//  Created by Kate on 28.05.2023.
//

import UIKit

final class WeatherViewController: UIViewController {
    private let moduleView = WeatherView()

    override func loadView() {
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
}

extension WeatherViewController {
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
            Task {
                do {
                    let weather = try await ApiService.shared.getWeather(lat: lat, lon: lon)
                    self?.moduleView.render(
                        .init(
                            date: weather.date ?? -1,
                            city: weather.name ?? "",
                            country: weather.sys?.country ?? "",
                            temperature: weather.main?.temp ?? -1,
                            mainWearher: weather.weather?.first?.main ?? "",
                            wind: weather.wind?.speed ?? -1,
                            visibilit: weather.visibility ?? -1,
                            humidity: weather.main?.humidity ?? -1,
                            airPressure: weather.main?.pressure ?? -1
                        )
                    )
                } catch {
                    print(error)
                }
            }
        }
    }
}
