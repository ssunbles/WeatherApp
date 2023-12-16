//
//  CityCollectionViewCell.swift
//  WeatherApp
//
//

import UIKit
//MARK: - CityCollectionViewCell
class CityCollectionViewCell: UICollectionViewCell {
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    //MARK: - setupUI
    private func setupUI() {
        addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    //MARK: - configure
    func configure(with cityName: String) {
        cityNameLabel.text = cityName
    }
}
