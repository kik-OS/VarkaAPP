//
//  ProductInfoCollectionViewCell.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 08.05.2021.
//

import UIKit

final class ProductInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var numberOfCardLabel: UILabel!
    @IBOutlet private weak var instructionLabel: UILabel!
    @IBOutlet private weak var instructionImage: UIImageView!
    @IBOutlet private weak var nextLabel: UILabel!
    
    var viewModel: ProductInfoCollectionViewCellViewModelProtocol! {
        didSet {
            numberOfCardLabel.text = viewModel?.numberOfCard
            instructionImage.image = UIImage(named: viewModel.instrImage)
            instructionLabel.text = viewModel.getInstrLabel()
            nextLabel.isHidden = viewModel.isShowNextLabel
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        layer.borderWidth = 0.3
        layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        clipsToBounds = false
    }
    
}
