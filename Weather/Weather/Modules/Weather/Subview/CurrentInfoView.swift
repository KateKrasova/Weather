//
//  CurrentInfoView.swift
//  Weather
//
//  Created by Kate on 28.05.2023.
//

import UIKit

final class CurrentInfoView: UIView {
    // MARK: - Props

    struct Props: Equatable {
        let title: String
        let value: String
    }

    // MARK: - Private Props

    private var props: Props?

    // MARK: - Views

    private lazy var titleLabel = UILabel()
    private lazy var valueLabel = UILabel()
    private lazy var stackView = UIStackView()

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)
        configure()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension CurrentInfoView {
    func render(_ props: Props) {
        guard self.props != props else { return }
        self.props = props

        titleLabel.text = props.title
        valueLabel.text = props.value
    }
}

// MARK: - Private Methods

private extension CurrentInfoView {
    func configure() {
        addSubview(stackView)

        titleLabel.font = UIFont(name: "Optima Bold", size: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        valueLabel.font = UIFont(name: "Optima Regular", size: 16)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
    }

    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
}
