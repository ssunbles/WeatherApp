//
//  CollectionViewCell.swift
//  WeatherApp
//
//

import UIKit
    //MARK: - WeatherForecastCollectionViewCell
class WeatherForecastCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(red: 188/256, green: 177/256, blue: 246/256, alpha: 1)
        return view
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.white
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.white
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.white
        return label
    }()
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - setupUI
    private func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.top.equalToSuperview().inset(10)
        }

        containerView.addSubview(dateLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(temperatureLabel)

        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    //MARK: - configure
    func configure(with forecastItem: ForecastItem) {
        dateLabel.text = forecastItem.date
        timeLabel.text = forecastItem.time
        iconImageView.image = UIImage(named: forecastItem.icon)
        temperatureLabel.text = "\(Int(forecastItem.temperature)) °C"
    }
}
