//
//  WeatherView.swift
//  Weather
//
//  Created by Kate on 28.05.2023.
//

import UIKit

final class WeatherView: UIView {
    // MARK: - Props

    struct Props: Equatable {
        var date: Int
        var city: String
        var country: String
        var temperature: Double
        var mainWearher: String

        var wind: Double
        var visibilit: Int
        var humidity: Int
        var airPressure: Int
    }

    // MARK: - Private Props

    private var props: Props?

    // MARK: - Views

    private lazy var dateLabel = UILabel()
    private lazy var cityLabel = UILabel()
    private lazy var countryLabel = UILabel()
    private lazy var locationStackView = UIStackView()

    private lazy var circleView = UIView()
    private lazy var temperatureLabel = UILabel()
    private lazy var weatherImage = UIImageView()

    private lazy var windLabel = CurrentInfoView()
    private lazy var visibilityLabel = CurrentInfoView()
    private lazy var humidityLabel = CurrentInfoView()
    private lazy var airLabel = CurrentInfoView()
    private lazy var infoStackView = UIStackView()
    private lazy var vStackViewFirst = UIStackView()
    private lazy var vStackViewSecond = UIStackView()

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)

        setup()
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods

extension WeatherView {
    func render(_ props: Props) {
        guard self.props != props else { return }
        self.props = props

        let date = Date(timeIntervalSince1970: TimeInterval(props.date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        dateLabel.text = dateFormatter.string(from: date)
        cityLabel.text = props.city
        countryLabel.text = props.country
        temperatureLabel.text = String(format: "%.1f", props.temperature) + "°C"

        windLabel.render(.init(title: "Wind speed", value: String(props.wind) + " mph"))

        humidityLabel.render(.init(title: "Humidity", value: String(props.humidity) + "%"))

        visibilityLabel.render(.init(title: "Visibility", value: String(props.visibilit) + " miles"))

        airLabel.render(.init(title: "Air", value: String(props.airPressure) + " mb"))

        weatherImage.image = UIImage(named: Icons(rawValue: props.mainWearher)?.icon ?? "sun")
    }
}

// MARK: - Private Methods

private extension WeatherView {
    func setup() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(named: "backgroundGradient")?.cgColor ?? UIColor.clear,
            UIColor(named: "background")?.cgColor ?? UIColor.clear
        ]
        gradient.frame = UIScreen.main.bounds
        layer.addSublayer(gradient)

        addSubview(locationStackView)
        addSubview(circleView)
        addSubview(infoStackView)
    }

    func setupViews() {
        dateLabel.font = UIFont(name: "Optima Regular", size: 16)
        dateLabel.textColor = .white

        cityLabel.font = UIFont(name: "Optima Bold", size: 40)
        cityLabel.textColor = .white
        cityLabel.text = "No city"

        countryLabel.font = UIFont(name: "Optima Regular", size: 20)
        countryLabel.textColor = .white
        countryLabel.text = "Please choose city"

        locationStackView.axis = .vertical
        locationStackView.spacing = -10
        locationStackView.alignment = .center
        locationStackView.distribution = .fillEqually
        locationStackView.addArrangedSubview(dateLabel)
        locationStackView.addArrangedSubview(cityLabel)
        locationStackView.addArrangedSubview(countryLabel)

        circleView.addSubview(temperatureLabel)
        circleView.addSubview(weatherImage)
        circleView.layer.cornerRadius = Constants.circleSize / 2
        circleView.backgroundColor = UIColor(named: "circleView")

        temperatureLabel.textColor = UIColor(named: "circleText")
        temperatureLabel.font = UIFont(name: "Optima Regular", size: 65)

        vStackViewFirst.axis = .vertical
        vStackViewFirst.spacing = 20
        vStackViewFirst.alignment = .center
        vStackViewFirst.addArrangedSubview(windLabel)
        vStackViewFirst.addArrangedSubview(humidityLabel)

        vStackViewSecond.axis = .vertical
        vStackViewSecond.spacing = 20
        vStackViewSecond.alignment = .center
        vStackViewSecond.addArrangedSubview(visibilityLabel)
        vStackViewSecond.addArrangedSubview(airLabel)

        infoStackView.axis = .horizontal
        infoStackView.spacing = 80
        infoStackView.alignment = .center
        infoStackView.addArrangedSubview(vStackViewFirst)
        infoStackView.addArrangedSubview(vStackViewSecond)
    }

    func setupConstraints() {
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        circleView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.translatesAutoresizingMaskIntoConstraints = false

        locationStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        locationStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        circleView.widthAnchor.constraint(equalToConstant: Constants.circleSize).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: Constants.circleSize).isActive = true
        circleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circleView.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 12).isActive = true

        temperatureLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: -59).isActive = true

        weatherImage.widthAnchor.constraint(equalToConstant: Constants.weatherImageSize).isActive = true
        weatherImage.heightAnchor.constraint(equalToConstant: Constants.weatherImageSize).isActive = true
        weatherImage.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true
        weatherImage.topAnchor.constraint(equalTo: circleView.topAnchor, constant: 20).isActive = true

        infoStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoStackView.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 20).isActive = true
    }
}

// MARK: - Constants

private extension WeatherView {
    enum Constants {
        static let circleSize = 240.0
        static let weatherImageSize = 75.0
    }
}

enum Icons: String {
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case snow = "Snow"
    case clear = "Clear"
    case clouds = "Clouds"
    case mist = "Mist"
    case fog = "Fog"
    case dust = "Dust"

    var icon: String {
        switch self {
        case .thunderstorm:
            return "stormy"

        case .drizzle:
            return "rain-cloud"

        case .rain:
            return "rainfall"

        case .snow:
            return "snow"

        case .clear:
            return "sun"

        case .clouds:
            return "clouds"

        case .mist, .fog, .dust:
            return "dust"
        }
    }
}
