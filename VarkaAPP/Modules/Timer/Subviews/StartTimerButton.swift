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
        layer.cornerRadius = layer.frame.height / 2
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
