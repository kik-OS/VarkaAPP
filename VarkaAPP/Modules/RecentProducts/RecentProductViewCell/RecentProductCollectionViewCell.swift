//
//  RecentProductCollectionViewCell.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 10.03.2021.
//

import UIKit

class RecentProductCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    var viewModel: RecentProductCollectionViewCellViewModelProtocol! {
        didSet {
            mainImageView.image = UIImage(named: viewModel.productImage)
            nameLabel.text = viewModel.productTitle
            producerLabel.text = viewModel.productProducer
        }
    }
    
    static let reuseID = "RecentProductCollectionViewCell"
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .yellow
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let producerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
         label.textColor = .yellow
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainImageView)
        addSubview(nameLabel)
        addSubview(producerLabel)
        backgroundColor = VarkaColors.mainColor
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 9
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 5, height: 8)
        self.clipsToBounds = false
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImageView.topAnchor.constraint(equalTo: topAnchor),
            mainImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 12),
            producerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            producerLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            producerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2, constant: 10)
        ])
    }
}
