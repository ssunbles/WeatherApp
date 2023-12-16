//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Айнур on 12.12.2023.
//

import UIKit
import SnapKit

//MARK: - WeatherViewController
class WeatherViewController: UIViewController {

    // MARK: - Properties
    var latitude: Double?
    var longitude: Double?
    var viewModel: WeatherViewModel?
    var forecastItems: [ForecastItem] = []

    private var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WeatherVC")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 45)
        label.textColor = UIColor.white
        return label
    }()

    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = UIColor.white
        return label
    }()

    private var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private var humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private var windSpeedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 180)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    // MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WeatherViewModel(latitude: latitude, longitude: longitude)
        setupUI()
        fetchWeatherData()
        fetchWeatherForFiveDays()
        collectionView.reloadData()
    }

    // MARK: - UI Setup
    private func setupUI() {
        setupBackgroundImage()
        setupNavigationBar()
        setupLabels()
        setupCollectionView()
    }

    // MARK: - setupBackgroundImage
    private func setupBackgroundImage() {
        view.addSubview(backgroundImage)
        backgroundImage.frame = CGRect(x: -698, y: -350, width: 1872, height: 1363)
    }

    // MARK: - setupNavigationBar
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
    }
    //MARK: - setupLabels
    private func setupLabels() {
        view.addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(115)
        }

        view.addSubview(weatherIconImageView)
        weatherIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalTo(cityNameLabel.snp.bottom)
            make.centerX.equalToSuperview().offset(-45)
        }

        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalTo(cityNameLabel.snp.bottom)
            make.leading.equalTo(weatherIconImageView.snp.trailing).offset(10)
        }

        view.addSubview(weatherDescriptionLabel)
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weatherIconImageView.snp.bottom).inset(10)
        }

        view.addSubview(feelsLikeLabel)
        feelsLikeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(60)
        }

        view.addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(feelsLikeLabel.snp.bottom).offset(5)
        }

        view.addSubview(windSpeedLabel)
        windSpeedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(humidityLabel.snp.bottom).offset(5)
        }
    }
    //MARK: - fetchWeatherData
    private func fetchWeatherData() {
        viewModel?.fetchWeatherData { [weak self] weatherData in
            guard let self = self, let weatherData = weatherData else {
                return
            }

            self.cityNameLabel.text = weatherData.name

            if let iconName = weatherData.weather?.first?.icon,
               let temperature = weatherData.main?.temp,
               let weatherDescription = weatherData.weather?.first?.description,
               let feelsLike = weatherData.main?.feelsLike,
               let humidity = weatherData.main?.humidity,
               let windSpeed = weatherData.wind?.speed {
                self.weatherIconImageView.image = UIImage(named: iconName)
                self.temperatureLabel.text = "\(Int(temperature)) °C"
                self.weatherDescriptionLabel.text = weatherDescription
                self.feelsLikeLabel.text = "Чувствуется как \(Int(feelsLike)) °C"
                self.humidityLabel.text = "Влажность: \(Int(humidity)) %"
                self.windSpeedLabel.text = "Скорость ветра \(Int(windSpeed)) м/с"
            }
        }
    }
    //MARK: - fetchWeatherForFiveDays
    private func fetchWeatherForFiveDays() {
        viewModel?.fetchWeatherDataForFiveDays { [weak self] weatherDataForFiveDays in
            guard let self = self, let weatherDataForFiveDays = weatherDataForFiveDays else {
                return
            }

            let dateFormatter = DateFormatter()
            let timeFormatter = DateFormatter()

            dateFormatter.dateFormat = "dd.MM.yyyy"
            timeFormatter.dateFormat = "HH:mm"

            self.forecastItems = weatherDataForFiveDays.list?.compactMap { listItem in
                guard let timestamp = listItem.dt,
                      let temperature = listItem.main?.temp,
                      let iconName = listItem.weather?.first?.icon else {
                    return nil
                }

                let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                let datePart = dateFormatter.string(from: date)
                let timePart = timeFormatter.string(from: date)
                print("Date: \(datePart), Time: \(timePart)")

                return ForecastItem(date: datePart, time: timePart, temperature: temperature, icon: iconName)
            } ?? []

            self.collectionView.reloadData()
        }
    }
    //MARK: - setupCollectionView
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(WeatherForecastCollectionViewCell.self, forCellWithReuseIdentifier: WeatherForecastCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(170)
            make.height.equalTo(180)
            make.width.equalToSuperview()
        }
    }
    //MARK: - goBack
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
    //MARK: - collectionViewMethods
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherForecastCollectionViewCell.identifier, for: indexPath) as? WeatherForecastCollectionViewCell else { return UICollectionViewCell() }

        let forecastItem = forecastItems[indexPath.item]
        cell.configure(with: forecastItem)

        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 180)
    }
}

