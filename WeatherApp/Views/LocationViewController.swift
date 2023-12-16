//
//  ViewController.swift
//  WeatherApp
//
//  Created by Айнур on 12.12.2023.
//

import UIKit
import SnapKit
//MARK: - LocationViewController
class LocationViewController: UIViewController {
    // MARK: - Properties
    var viewModel: LocationViewModel!
    var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LocationVCImage")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    let detectLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Определить местоположение", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(red: 38/256, green: 42/256, blue: 56/256, alpha: 1)
        button.layer.cornerRadius = 16
        return button
    }()

    let manuallyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ввести вручную", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(red: 38/256, green: 42/256, blue: 56/256, alpha: 1)
        button.layer.cornerRadius = 16
        return button
    }()

    var buttonsStackView = UIStackView()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LocationViewModel()
        viewModel.delegate = self
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        setupBackgroundImage()
        setupButtons()
    }

    // MARK: - setupBackgroundImage
    private func setupBackgroundImage() {
        view.addSubview(backgroundImage)
        backgroundImage.frame = CGRect(x: -157, y: -101, width: 934, height: 1120)
    }

    // MARK: - setupButtons
    private func setupButtons() {
        detectLocationButton.addTarget(self, action: #selector(detectLocationButtonTapped), for: .touchUpInside)
        detectLocationButton.snp.makeConstraints { make in
            make.width.equalTo(330)
            make.height.equalTo(70)
        }
        manuallyButton.addTarget(self, action: #selector(manuallyButtonTapped), for: .touchUpInside)
        manuallyButton.snp.makeConstraints { make in
            make.width.equalTo(330)
            make.height.equalTo(70)
        }

        buttonsStackView = UIStackView(arrangedSubviews: [detectLocationButton, manuallyButton])
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 35

        view.addSubview(buttonsStackView)

        buttonsStackView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(400)
        }
    }

    // MARK: - ButtonsTapped
    @objc private func detectLocationButtonTapped() {
        print("кнопка нажата")
        viewModel?.detectLocationButtonTapped()
    }

    @objc private func manuallyButtonTapped() {
        viewModel?.manuallyButtonTapped()
    }
}

extension LocationViewController: LocationViewModelDelegate {
    //MARK: - didTapDetectLocationButton
    func didTapDetectLocationButton(latitude: Double, longitude: Double, city: String) {
        let alert = UIAlertController(title: "Геолокация получена!", message: "Широта: \(latitude)\nДолгота: \(longitude)\nГород: \(city)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { _ in
            let weatherViewController = WeatherViewController()
            weatherViewController.latitude = latitude
            weatherViewController.longitude = longitude
            self.navigationController?.pushViewController(weatherViewController, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
//MARK: - didTapManuallyButton
    func didTapManuallyButton() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}
