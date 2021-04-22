//
//  StartTimerButton.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 22.04.2021.
//

import UIKit

final class StartTimerButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = UIConstants.defaultCornerRadius
        clipsToBounds = true
        titleLabel?.textColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isEnabled
            ? UIConstants.startTimerButtonEnabledColor
            : UIConstants.startTimerButtonDisabledColor
    }
}
