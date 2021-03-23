//
//  AddingNewProductViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//

import UIKit

final class AddingNewProductViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var titleProductTF: UITextField!
    @IBOutlet weak var producerTF: UITextField!
    @IBOutlet weak var cookingTimeTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var waterRatioTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    // MARK: - Properties
    
    var viewModel: AddingNewProductViewModelProtocol! {
        didSet {
            viewModel.getCategories()
        }
    }
    
    // MARK: - Private Properties
    
    private let pickerViewForKB = UIPickerView()
    private let doneButtonForKB = UIBarButtonItem()
    
    // MARK: - Override methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let productInfoVC = segue.destination as? ProductInfoViewController else { return }
        productInfoVC.viewModel = ProductInfoViewModel(product: viewModel.completedProduct)
    }
    
    // MARK: - IB Actions
    
    @IBAction func textFieldsEditingDidBegin(_ sender: UITextField) {
        viewModel.indexOfFirstResponder = sender.tag
        viewModel.updatePickerViewIfNeeded(index: sender.tag) { [weak self] in
            self?.pickerViewForKB.reloadAllComponents()
        }
    }
    
    @IBAction func textFieldsEditingChanged(_ sender: UITextField) {
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
    
    
    @IBAction func needStirringSwitch(_ sender: UISwitch) {
        viewModel.needStirring = sender.isOn
    }
    
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed() {
        viewModel.createProductInFB()
        Notifications().showProductWasAddedNotification()
        performSegue(withIdentifier: Inscriptions.unwindToProductInfoSegueID, sender: nil)
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeLabel.text = viewModel.codeLabelText
        addToolBar(to: categoryTF, titleProductTF, producerTF, cookingTimeTF, weightTF, waterRatioTF)
        initializePickerView()
        configureObservers()
        configureGestureRecognizer()
    }
    
    // MARK: - Private Methods
    
    private func configureGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(oneTouchOnScrollView))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        mainScrollView.addGestureRecognizer(recognizer)
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
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
    
    private func createToolBar() -> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        doneButtonForKB.tintColor = .white
        doneButtonForKB.isEnabled = false
        doneButtonForKB.title = Inscriptions.titleOfDoneButtonForKB
        doneButtonForKB.style = .plain
        doneButtonForKB.action = #selector(didTapOnDoneButton)
        
        let downButtonForKB = UIBarButtonItem()
        downButtonForKB.tintColor = .white
        downButtonForKB.action = #selector(didTapOnDownButton)
        downButtonForKB.image = UIImage(systemName: ImageTitles.toolBarDownButton)
        downButtonForKB.style = .plain
        
        let upButtonForKB = UIBarButtonItem()
        upButtonForKB.tintColor = .white
        upButtonForKB.action = #selector(didTapOnUpButton)
        upButtonForKB.image = UIImage(systemName: ImageTitles.toolBarUpButton)
        upButtonForKB.style = .plain
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 14
        
        keyboardToolbar.items = [downButtonForKB, space, upButtonForKB, flexBarButton, doneButtonForKB]
        keyboardToolbar.backgroundColor = .systemIndigo
        keyboardToolbar.barTintColor = .systemIndigo
        return keyboardToolbar
    }
    
    
    private func addToolBar(to textFields: UITextField...) {
        let keyboardToolbar = createToolBar()
        textFields.forEach { textField in
            textField.inputAccessoryView = keyboardToolbar
        }
    }
    
    private func changedResponderForUpButton() {
        let textFields = [categoryTF, titleProductTF, producerTF, cookingTimeTF, weightTF, waterRatioTF]
        textFields[viewModel.calculationOfUpperResponder()]?.becomeFirstResponder()
    }
    
    private func changedResponderForDownButton() {
        let textFields = [categoryTF, titleProductTF, producerTF, cookingTimeTF, weightTF, waterRatioTF]
        textFields[viewModel.calculationOfLowerResponder()]?.becomeFirstResponder()
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
        viewModel.pickerViewDidSelected { [weak self] in
            self?.categoryTF.text = self?.viewModel.categories[row].name
            self?.viewModel.textFromCategoryTF = self?.viewModel.categories[row].name
        } completionWaterRatio: { [weak self] in
            self?.waterRatioTF.text = self?.viewModel.listOfWaterRatio[row]
            self?.viewModel.textFromWaterRatioTF = self?.viewModel.listOfWaterRatio[row]
            self?.viewModel.calculateWaterRatio(row: row)
        }
        updateSaveButtonsState()
    }
}

