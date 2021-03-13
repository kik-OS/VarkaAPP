//
//  TimerSettingViewController.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 13.03.2021.
//

import UIKit

final class TimerSettingViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc private func dismissByTapAction() {
        dismiss(animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        contentView.layer.cornerRadius = 15
        
        let dismissByTapGR = UITapGestureRecognizer(target: self,
                                                    action: #selector(dismissByTapAction))
        backgroundView.addGestureRecognizer(dismissByTapGR)
    }
}
