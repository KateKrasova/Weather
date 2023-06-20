//
//  SearchView.swift
//  Weather
//
//  Created by Kate on 12.06.2023.
//

import UIKit

final class SearchView: UIView {
    // MARK: - Props

    struct Props: Equatable {
        let names: [String]
    }

    var textChanged: ((String) -> Void)?
    var cellTapped: ((Int) -> Void)?

    // MARK: - Private Props

    private var props: Props?
    private var names: [String] = []

    // MARK: - Views

    private lazy var mainView = UIView()
    private lazy var searchBar = UISearchBar()
    private lazy var listTableView = UITableView()

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

extension SearchView {
    func render(_ props: Props) {
        guard self.props != props else { return }
        self.props = props

        names = props.names
        listTableView.reloadData()
    }
}

// MARK: - Private Methods

private extension SearchView {
    func setup() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(named: "backgroundGradient")?.cgColor ?? UIColor.clear,
            UIColor(named: "background")?.cgColor ?? UIColor.clear
        ]
        gradient.frame = UIScreen.main.bounds
        layer.addSublayer(gradient)

        addSubview(mainView)
        addSubview(searchBar)
        addSubview(listTableView)
    }

    func setupViews() {
        mainView.layer.cornerRadius = 35
        mainView.backgroundColor = .white

        searchBar.placeholder = "Search location"
        searchBar.searchBarStyle = .minimal

        searchBar.searchTextField.addAction(
            UIAction { [weak self] _ in
            guard let text = self?.searchBar.text else {return}

            self?.textChanged?(text)
            },
            for: .editingChanged
        )

        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        listTableView.translatesAutoresizingMaskIntoConstraints = false

        mainView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: Constants.mainViewHeight).isActive = true

        searchBar.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 45).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true

        listTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        listTableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30).isActive = true
        listTableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -30).isActive = true
    }
}

extension SearchView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellTapped?(indexPath.row)
    }
}

// MARK: - Constants

private extension SearchView {
    enum Constants {
        static let mainViewHeight: CGFloat = 400
    }
}
