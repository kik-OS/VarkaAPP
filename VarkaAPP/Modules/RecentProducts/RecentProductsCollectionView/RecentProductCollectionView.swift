//
//  RecentProductCollectionView.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 10.03.2021.
//

import UIKit

class RecentProductCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var viewModel: RecentProductCollectionViewViewModelProtocol! {
        didSet {
//            viewModel.fetchProducts { [weak self] in
//                self?.reloadData()
            viewModel.fetchProductFromCoreData { [weak self] in
                self?.reloadData()
            }
            }
        }
    
    
    // MARK: - Initializer 
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .systemGray
        delegate = self
        dataSource = self
        register(RecentProductCollectionViewCell.self, forCellWithReuseIdentifier: RecentProductCollectionViewCell.reuseID)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = ConstantsCollectionView.productsCollectionMinimumLineSpacing
        contentInset = UIEdgeInsets(top: 0, left: ConstantsCollectionView.leftDistanceToView, bottom: 0, right: ConstantsCollectionView.rightDistanceToView)
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: RecentProductCollectionViewCell.reuseID, for: indexPath) as! RecentProductCollectionViewCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ConstantsCollectionView.productsCollectionItemWidth, height: frame.height * 0.9)
    }
    
}
