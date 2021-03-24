//
//  AddingNewProductViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//

import UIKit

final class AddingNewProductViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak private var codeLabel: UILabel!
    @IBOutlet weak private var categoryTF: UITextField!
    @IBOutlet weak private var titleProductTF: UITextField!
    @IBOutlet weak private var producerTF: UITextField!
    @IBOutlet weak private var cookingTimeTF: UITextField!
    @IBOutlet weak private var weightTF: UITextField!
    @IBOutlet weak private var waterRatioTF: UITextField!
    @IBOutlet weak private var saveButton: UIButton!
    @IBOutlet weak private var mainScrollView: UIScrollView!
    
    // MARK: - Properties
    
    var viewModel: AddingNewProductViewModelProtocol!
    
    // MARK: - Private Properties
    
    private let pickerViewForKB = UIPickerView()
    private let doneButtonForKB = UIBarButtonItem()
    private let downButtonForKB = UIBarButtonItem()
    private let upButtonForKB = UIBarButtonItem()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VarkaColors.mainColor
        codeLabel.text = viewModel.codeLabelText
        addToolBar(to: categoryTF, titleProductTF, producerTF, cookingTimeTF, weightTF, waterRatioTF)
        initializePickerView()
        configureObservers()
        configureGestureRecognizer()
        setupViewModelBindings()
    }
    
    // MARK: - IB Actions
    
    @IBAction private func textFieldsEditingDidBegin(_ sender: UITextField) {
        viewModel.indexOfFirstResponder = sender.tag
        viewModel.updatePickerViewIfNeeded(index: sender.tag) { [weak self] in
            self?.pickerViewForKB.reloadAllComponents()
        }
        updateUpAndDownButtonsState()
    }
    
    @IBAction private func textFieldsEditingChanged(_ sender: UITextField) {
        switch sender {
        case titleProductTF:
            viewModel.textFromTitleProductTF = sender.text
        case producerTF:
            viewModel.textFromProducerTF = sender.text
        case cookingTimeTF:
            viewModel.textFromCookingTimeTF = sender.text
        case weightTF:
            viewModel.textFromWeightTF = sender.text
        default:
            break
        }
        updateSaveButtonsState()
    }
    
    
    @IBAction private func needStirringSwitch(_ sender: UISwitch) {
        viewModel.needStirring = sender.isOn
    }
    
    
    @IBAction private func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @IBAction private func saveButtonPressed() {
        viewModel.createProductInFB()
        Notifications.shared.showProductWasAddedNotification()
        performSegue(withIdentifier: Inscriptions.unwindToProductInfoSegueID, sender: nil)
    }
    
    // MARK: - Private Methods
    private func setupViewModelBindings() {
        viewModel.needUpdateTextFieldWithPickerView = { [unowned self] type, text in
            switch type {
            case .category:
                categoryTF.text = text
            case .waterRatio:
                waterRatioTF.text = text
            }
        }
    }
    
    private func configureGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(oneTouchOnScrollView))
        mainScrollView.addGestureRecognizer(recognizer)
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let productInfoVC = segue.destination as? ProductInfoViewController else { return }
        productInfoVC.viewModel = viewModel.getProductInfoViewModel()
    }
}



//MARK: - Extensions

extension AddingNewProductViewController: UITextFieldDelegate {
    
    @objc private func oneTouchOnScrollView() {
        view.endEditing(true)
    }
    
    @objc private func didTapOnDoneButton() {
        saveButtonPressed()
    }
    
    @objc private func didTapOnUpButton() {
        changedResponderForUpButton()
    }
    
    @objc private func didTapOnDownButton() {
        changedResponderForDownButton()
    }
    
    @objc private func keyBoardDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        (view as! UIScrollView).contentSize = CGSize(width: view.bounds.size.width,
                                                     height: view.bounds.size.height + kbFrameSize.height + 40)
        (view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc private func keyBoardDidHide() {
        (view as! UIScrollView).contentSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    
    private func updateSaveButtonsState() {
        let state = viewModel.validation()
        saveButton.isEnabled = state
        doneButtonForKB.isEnabled = state
    }
    
    private func updateUpAndDownButtonsState() {
        upButtonForKB.isEnabled = viewModel.stateForUpButton
        downButtonForKB.isEnabled = viewModel.stateForDownButton
    }
    
    private func createToolBar() -> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        doneButtonForKB.tintColor = .white
        doneButtonForKB.isEnabled = false
        doneButtonForKB.title = Inscriptions.titleOfDoneButtonForKB
        doneButtonForKB.style = .plain
        doneButtonForKB.action = #selector(didTapOnDoneButton)
        
        downButtonForKB.tintColor = .white
        downButtonForKB.action = #selector(didTapOnDownButton)
        downButtonForKB.image = UIImage(systemName: ImageTitles.toolBarDownButton)
        downButtonForKB.style = .plain
        
        upButtonForKB.tintColor = .white
        upButtonForKB.action = #selector(didTapOnUpButton)
        upButtonForKB.image = UIImage(systemName: ImageTitles.toolBarUpButton)
        upButtonForKB.style = .plain
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 14
        
        keyboardToolbar.items = [downButtonForKB, space, upButtonForKB, flexBarButton, doneButtonForKB]
        keyboardToolbar.backgroundColor = VarkaColors.mainColor
        keyboardToolbar.barTintColor = VarkaColors.mainColor
        return keyboardToolbar
    }
    
    
    private func addToolBar(to textFields: UITextField...) {
        let keyboardToolbar = createToolBar()
        textFields.forEach { textField in
            textField.inputAccessoryView = keyboardToolbar
        }
    }
    
    private func changedResponderForUpButton() {
        let textFields: Set = [categoryTF, titleProductTF, producerTF, cookingTimeTF, weightTF, waterRatioTF]
        let tag = viewModel.calculationOfUpperResponder()
        guard let targetTF = textFields.first(where: { $0?.tag == tag}) else { return }
        targetTF?.becomeFirstResponder()
    }
    
    private func changedResponderForDownButton() {
        let textFields: Set = [categoryTF, titleProductTF, producerTF, cookingTimeTF, weightTF, waterRatioTF]
        let tag = viewModel.calculationOfLowerResponder()
        guard let targetTF = textFields.first(where: { $0?.tag == tag}) else { return }
        targetTF?.becomeFirstResponder()
    }
}


extension AddingNewProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    private func initializePickerView() {
        categoryTF.inputView = pickerViewForKB
        waterRatioTF.inputView = pickerViewForKB
        pickerViewForKB.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfRowsInPickerView
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.dataForPickerView[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.pickerViewDidSelectAt(row: row)
        updateSaveButtonsState()
    }
}


