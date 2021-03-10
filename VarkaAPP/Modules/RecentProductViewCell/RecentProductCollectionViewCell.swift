//
//  RecentProductCollectionViewCell.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 10.03.2021.
//

import UIKit

class RecentProductCollectionViewCell: UICollectionViewCell {

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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainImageView)
        addSubview(nameLabel)
        addSubview(producerLabel)
        
        backgroundColor = .systemIndigo
        mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 12).isActive = true
        
        producerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        producerLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        producerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2, constant: 10).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 9
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 5, height: 8)
        self.clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
