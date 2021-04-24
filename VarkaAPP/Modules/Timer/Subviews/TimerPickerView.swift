//
//  TimerPickerView.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 16.03.2021.
//

import UIKit

final class TimerPickerView: UIPickerView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        subviews.last?.backgroundColor = .clear
    }
}
