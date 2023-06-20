//
//  SearchViewController.swift
//  Weather
//
//  Created by Kate on 12.06.2023.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: - Private Props

    private lazy var moduleView = SearchView()

    // MARK: - Props

    var currentResponse: GeocodingResponse?
    var updateCoordinates: ((Double, Double) -> Void)?

    // MARK: - LifeCycle

    override func loadView() {
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = .white

        moduleView.textChanged = { [weak self] text in
            Task {
                do {
                    self?.currentResponse = try await ApiService.shared.getCoordinates(query: text)
                    guard let response = self?.currentResponse else {return}

                    self?.moduleView.render(
                        .init(
                            names: response.compactMap { response in
                                guard let name = response.name, let country = response.country else {return nil}
                                return name + " " + country
                            }
                        )
                    )
                } catch {
                    print(error)
                }
            }
        }

        moduleView.cellTapped = { [weak self] index in
            let lat = self?.currentResponse?[index].lat
            let lon = self?.currentResponse?[index].lon

            guard let lat, let lon else {return}

            self?.updateCoordinates?(lat, lon)
            StorageService.shared.saveCords(value: (lat, lon))
            print("saved")

            self?.navigationController?.popViewController(animated: true)
        }
    }
}
