//
//  TimerViewController.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 13.03.2021.
//

import SwiftUI

final class TimerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var pickerStackView: UIStackView!
    @IBOutlet private weak var diagramStackView: UIStackView!
    @IBOutlet private weak var minutesPickerView: TimerPickerView!
    @IBOutlet private weak var minLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    
    // MARK: - Properties
    
    var viewModel: TimerViewModelProtocol
    
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
        setupViewModelBindings()
        setShadow()
    }
    
    // MARK: - Actions
    
    @objc private func dismissByTapAction() {
        dismiss(animated: true)
    }
    
    @IBAction private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @IBAction private func startButtonTapped() {
        viewModel.startTimer()
        showDiagram()
        updateStatesOfButtons()
    }
    
    @IBAction func stopButtonTapped() {
        viewModel.stopTimer()
        hideDiagram()
        updateStatesOfButtons()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.layer.cornerRadius = UIConstants.defaultCornerRadius
        startButton.layer.cornerRadius = UIConstants.defaultCornerRadius
        stopButton.layer.cornerRadius =  UIConstants.defaultCornerRadius
        
        updateStatesOfStackViews()
        updateStatesOfButtons()
        setTimeDiagramView()
        minutesPickerView.selectRow(viewModel.minutes, inComponent: 0, animated: false)
        
        let dismissByTapGR = UITapGestureRecognizer(target: self,
                                                    action: #selector(dismissByTapAction))
        backgroundView.addGestureRecognizer(dismissByTapGR)
    }
    
    // MARK: - Private methods
    
    private func setupViewModelBindings() {
        viewModel.timerDidStep = { [unowned self] totalSeconds, remainingSeconds in
            setTimeDiagramView(totalSeconds: totalSeconds, remainingSeconds: remainingSeconds)
        }
        
        viewModel.timerDidStop = { [unowned self] in
            hideDiagram()
        }
    }
    
    private func setTimeDiagramView(totalSeconds: Int? = nil, remainingSeconds: Int? = nil) {
        let totalSeconds = totalSeconds ?? viewModel.timerTime.totalSeconds
        let remainingSeconds = remainingSeconds ?? viewModel.timerTime.remainingSeconds
        
        let timeDiagramView = UIHostingController(rootView: TimeDiagram(
            width: 200, height: 150,
            totalSeconds: totalSeconds, remainingSeconds: remainingSeconds
        ))
        diagramStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        diagramStackView.addArrangedSubview(timeDiagramView.view)
    }
    
    private func updateStatesOfButtons() {
        startButton.isHidden = viewModel.isHiddenStartButton
        stopButton.isHidden = viewModel.isHiddenStopButton
        startButton.isEnabled = viewModel.isEnabledStartButton
        startButton.backgroundColor = startButton.isEnabled
            ? UIConstants.buttonEnabledColor
            : UIConstants.buttonDisabledColor
    }
    
    private func updateStatesOfStackViews() {
        pickerStackView.isHidden = viewModel.isHiddenPickerStackView
        diagramStackView.isHidden = viewModel.isHiddenDiagramStackView
    }
    
    private func showDiagram() {
        pickerStackView.disappear() { [weak self] in
            self?.setTimeDiagramView()
            self?.diagramStackView.appear()
        }
    }
    
    private func hideDiagram() {
        diagramStackView.disappear() { [weak self] in
            self?.pickerStackView.appear()
        }
    }
    
    private func setShadow() {
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
}

// MARK: - Picker view data source

extension TimerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        90
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(row)"
    }
}

// MARK: - Picker view delegate

extension TimerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.updateTimeTo(minutes: minutesPickerView.selectedRow(inComponent: 0))
        updateStatesOfButtons()
    }
}
