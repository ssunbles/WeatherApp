//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Айнур on 12.12.2023.
//

import UIKit
import SnapKit
import CoreLocation

//MARK: - SearchViewController
class SearchViewController: UIViewController {
    // MARK: - Properties
    var viewModel: SearchViewModel!
    weak var delegate: SearchViewControllerDelegate?
    var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SearchVC")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название города"
        textField.borderStyle = .roundedRect
        return textField
    }()

    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Поиск", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(red: 38/256, green: 42/256, blue: 56/256, alpha: 1)
        button.layer.cornerRadius = 16
        return button
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 15
        collectionView.backgroundColor = UIColor(red: 142/256, green: 232/256, blue: 211/256, alpha: 1)
        return collectionView
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel()
        viewModel.delegate = self
        setupUI()

        viewModel.loadCities()
        collectionView.reloadData()
    }

    // MARK: - UI Setup
    private func setupUI() {
        setupBackgroundImage()
        setupSearchTextField()
        setupSearchButton()
        setupNavigationBar()
        setupCollectionView()
    }

    // MARK: - setupBackgroundImage
    private func setupBackgroundImage() {
        view.addSubview(backgroundImage)
        backgroundImage.frame = CGRect(x: -544, y: -866, width: 1200, height: 1798)
    }

    // MARK: - setupNavigationBar
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
    }

    // MARK: - setupSearchTextField
    private func setupSearchTextField() {
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(300)
            make.width.equalTo(340)
            make.height.equalTo(50)
        }
    }
    //MARK: - setupCollectionView
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(40)
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
    }
    //MARK: - setupSearchButton
    private func setupSearchButton() {
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    //MARK: - searchButtonTapped
    @objc private func searchButtonTapped() {
        guard let cityName = searchTextField.text, !cityName.isEmpty else { return }
        viewModel.searchButtonTap(with: cityName)
    }
    //MARK: - goBack
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: SearchViewControllerDelegate {
    //MARK: - didTapSearchButton
    func didTapSearchButton(cityName: String, latitude: Double, longitude: Double) {
        CoreDataManager.shared.saveCity(name: cityName, latitude: latitude, longitude: longitude)

        let weatherViewController = WeatherViewController()
        weatherViewController.latitude = latitude
        weatherViewController.longitude = longitude

        navigationController?.pushViewController(weatherViewController, animated: true)
        delegate?.didTapSearchButton(cityName: cityName, latitude: latitude, longitude: longitude)
        collectionView.reloadData()
    }
    //MARK: - didLoadCities
    func didLoadCities() {
        collectionView.reloadData()
    }
}
//MARK: - CollectionViewMethods
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as? CityCollectionViewCell else { return UICollectionViewCell() }
        let city = viewModel.cities[indexPath.row]
        cell.configure(with: city.name ?? "default")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCity = viewModel.cities[indexPath.row]
        let cityName = selectedCity.name ?? "Default City"
        didTapSearchButton(cityName: cityName, latitude: selectedCity.latitude, longitude: selectedCity.longitude)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 40)
    }
}
