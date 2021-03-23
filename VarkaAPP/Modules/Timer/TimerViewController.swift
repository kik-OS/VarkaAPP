//
//  TimerViewController.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 13.03.2021.
//

import UIKit

final class TimerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var minutesPickerView: TimerPickerView!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Properties
    
    let viewModel: TimerViewModelProtocol
    
    // MARK: - Initializers
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: TimerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc private func dismissByTapAction() {
        dismiss(animated: true)
    }
    
    @IBAction func startButtonTapped() {
        
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.layer.cornerRadius = UIConstants.defaultCornerRadius
        startButton.layer.cornerRadius = UIConstants.defaultCornerRadius
        updateStartButton()
        minutesPickerView.selectRow(viewModel.minutes, inComponent: 0, animated: false)
        
        let dismissByTapGR = UITapGestureRecognizer(target: self,
                                                    action: #selector(dismissByTapAction))
        backgroundView.addGestureRecognizer(dismissByTapGR)
    }
    
    // MARK: - Private methods
    private func updateStartButton() {
        startButton.isEnabled = viewModel.isEnabledStartButton
        startButton.backgroundColor = startButton.isEnabled
            ? UIConstants.buttonEnabledColor
            : UIConstants.buttonDisabledColor
    }
}

// MARK: - Picker view data source

extension TimerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(describing: row)
    }
}

// MARK: - Picker view delegate

extension TimerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.updateTimeTo(minutes: minutesPickerView.selectedRow(inComponent: 0))
        updateStartButton()
    }
}
