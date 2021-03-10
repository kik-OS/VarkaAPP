//
//  RecentProductCollectionView.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 10.03.2021.
//

import UIKit

class RecentProductCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var products: [Product] = []
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .systemGray
        delegate = self
        dataSource = self
        register(RecentProductCollectionViewCell.self, forCellWithReuseIdentifier: RecentProductCollectionViewCell.reuseID)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = Constants.productsCollectionMinimumLineSpacing
        contentInset = UIEdgeInsets(top: 0, left: Constants.leftDistanceToView, bottom: 0, right: Constants.rightDistanceToView)
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(products: [Product]) {
        self.products = products
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: RecentProductCollectionViewCell.reuseID, for: indexPath) as! RecentProductCollectionViewCell
        
        cell.mainImageView.image = UIImage(named: "rice.png")
        cell.nameLabel.text = products[indexPath.row].title
        cell.producerLabel.text = products[indexPath.row].producer
            
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.productsCollectionItemWidth, height: frame.height * 0.9)
    }
    
}
