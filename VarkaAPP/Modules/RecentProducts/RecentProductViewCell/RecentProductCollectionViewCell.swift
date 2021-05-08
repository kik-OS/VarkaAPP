//
//  RecentProductCollectionViewCell.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 10.03.2021.
//

import UIKit

final class RecentProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: RecentProductCollectionViewCellViewModelProtocol! {
        didSet {
            mainImageView.image = UIImage(named: viewModel.productImage)
            nameLabel.text = viewModel.productTitle
            producerLabel.text = viewModel.productProducer
            cookingTimeLabel.text = viewModel.productCookingTime
            barcodeLabel.text = viewModel.productBarcode
            weightLabel.text = viewModel.productWeight
        }
    }
    
    static let reuseID = "RecentProductCollectionViewCell"
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        imageView.clipsToBounds = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Regular", size: 22)
        label.textColor = VarkaColors.mainColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let barcodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Regular", size: 15)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let producerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Regular", size: 15)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Regular", size: 15)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cookingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Regular", size: 18)
        label.textColor = VarkaColors.mainColor
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainImageView)
        addSubview(nameLabel)
        addSubview(producerLabel)
        addSubview(cookingTimeLabel)
        addSubview(barcodeLabel)
        addSubview(weightLabel)
        backgroundColor = .white
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        clipsToBounds = false
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImageView.topAnchor.constraint(equalTo: topAnchor, constant: -25),
            mainImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/1.7),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 12),
            barcodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            barcodeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            barcodeLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2, constant: 10),
            producerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            producerLabel.topAnchor.constraint(equalTo: barcodeLabel.bottomAnchor, constant: 4),
            producerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2, constant: 10),
            weightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            weightLabel.topAnchor.constraint(equalTo: producerLabel.bottomAnchor, constant: 4),
            weightLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2, constant: 10),
            cookingTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cookingTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            cookingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
