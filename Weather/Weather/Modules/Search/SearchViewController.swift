//
//  SearchViewController.swift
//  Weather
//
//  Created by Kate on 12.06.2023.
//

import UIKit

final class SearchViewController: UIViewController {
    private lazy var moduleView = SearchView()

    var currentResponse: GeocodingResponse?

    var updateCoordinates: ((Double, Double) -> Void)?

    override func loadView() {
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

            self?.navigationController?.popViewController(animated: true)
        }
    }
}
