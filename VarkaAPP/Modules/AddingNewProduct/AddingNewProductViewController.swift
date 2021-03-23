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
    
    let doneButton = UIBarButtonItem(title:"Сохранить", style: .done, target: self,action: #selector(didTapOnDoneButton))
    
    // MARK: - Properties
    
    var viewModel: AddingNewProductViewModelProtocol! {
        didSet {
            viewModel.getCategories()
        }
    }
    
    // MARK: - Actions
    
    
    
    @IBAction func textFieldsTouchUpInside(_ sender: UITextField) {
        
        ////////////////////
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
    
    
    // MARK: - Override methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let productInfoVC = segue.destination as? ProductInfoViewController else { return }
        productInfoVC.viewModel = ProductInfoViewModel(product: viewModel.completedProduct)
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
        doneButton.isEnabled = state
    }
    
    private func createToolBar() -> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let downButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(didTapOnDownButton))
        let upButton = UIBarButtonItem(title:"", style: .plain, target: self, action: #selector(didTapOnUpButton))
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 14
        doneButton.tintColor = .white
        doneButton.isEnabled = viewModel.validation()
        downButton.tintColor = .white
        downButton.image = UIImage(systemName: "arrow.down")
        upButton.tintColor = .white
        upButton.image = UIImage(systemName: "arrow.up")
        keyboardToolbar.items = [downButton, space, upButton, flexBarButton, doneButton]
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
        
        if titleProductTF.isFirstResponder {
            categoryTF.becomeFirstResponder()
        }else if producerTF.isFirstResponder {
            titleProductTF.becomeFirstResponder()
        } else if cookingTimeTF.isFirstResponder {
            producerTF.becomeFirstResponder()
        } else if weightTF.isFirstResponder {
            cookingTimeTF.becomeFirstResponder()
        } else if waterRatioTF.isFirstResponder {
            weightTF.becomeFirstResponder()
        }
    }
    
    private func changedResponderForDownButton() {
        if waterRatioTF.isFirstResponder {
            view.endEditing(true)
        } else if weightTF.isFirstResponder {
            waterRatioTF.becomeFirstResponder()
        } else if cookingTimeTF.isFirstResponder {
            weightTF.becomeFirstResponder()
        } else if producerTF.isFirstResponder {
            cookingTimeTF.becomeFirstResponder()
        } else if titleProductTF.isFirstResponder {
            producerTF.becomeFirstResponder()
        } else if categoryTF.isFirstResponder {
            titleProductTF.becomeFirstResponder()
        }
    }
}


extension AddingNewProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func initializePickerView() {
        let pickerViewForKB = UIPickerView()
        categoryTF.inputView = pickerViewForKB
        waterRatioTF.inputView = pickerViewForKB
        pickerViewForKB.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if categoryTF.isFirstResponder {
            return viewModel.categories.count
        }
        return viewModel.listOfWaterRatio.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if categoryTF.isFirstResponder {
            return viewModel.categories[row].name
        }
        return viewModel.listOfWaterRatio[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if categoryTF.isFirstResponder {
            categoryTF.text = viewModel.categories[row].name
            viewModel.textFromCategoryTF = viewModel.categories[row].name
            updateSaveButtonsState()
        } else {
            waterRatioTF.text = viewModel.listOfWaterRatio[row]
            viewModel.textFromWaterRatioTF = viewModel.listOfWaterRatio[row]
            viewModel.calculateWaterRatio(row: row)
            updateSaveButtonsState()
        }
        
    }
}

