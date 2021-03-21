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
    
    // MARK: - Properties
    
    var viewModel: AddingNewProductViewModelProtocol! {
        didSet {
            viewModel.getCategories()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func weightProductEditingChanged() {
        viewModel.textFromWeightTF = weightTF.text
    }
    @IBAction func needStirringSwitch(_ sender: UISwitch) {
        viewModel.needStirring = sender.isOn
    }
    
    @IBAction func titleProductEditingChanged() {
        viewModel.textFromTitleProductTF = titleProductTF.text
    }
    @IBAction func cookingTimeEditingChanged() {
        viewModel.textFromCookingTimeTF = cookingTimeTF.text
    }
    @IBAction func producerProductEditingChanged() {
        viewModel.textFromProducerTF = producerTF.text
    }
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed() {
        viewModel.validation() ?
            successfulValidation() :
            showAlert()
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeLabel.text = viewModel.codeLabelText
        addToolBar(to: categoryTF, titleProductTF, producerTF, cookingTimeTF, weightTF, waterRatioTF)
        initializePickerView()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        
    }
    
    @objc private func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height + 40)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc private func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    
    
    // MARK: - Private methods
    
    private func showAlert() {
        let alert = UIAlertController(title: "Упс...",
                                      message: viewModel.incorrectMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) 
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    private func successfulValidation() {
        viewModel.codeLabelText = codeLabel.text
        viewModel.initializeProduct()
        viewModel.createProductInFB()
        Notifications().showProductWasAddedNotification()
        performSegue(withIdentifier: "unwindToProductInfo", sender: nil)
    }
    
    // MARK: - Override methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let productInfoVC = segue.destination as? ProductInfoViewController else { return }
        productInfoVC.viewModel = ProductInfoViewModel(product: viewModel.completedProduct)
    }
}





//MARK: - Extensions

extension AddingNewProductViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }


    
    @objc private func didTapDone() {
        saveButtonPressed()
        //            view.endEditing(true)
    }
    
    @objc private func didTapUp() {
        changedResponderForUpButton()
    }
    
    @objc private func didTapDown() {
        changedResponderForDownButton()
    }
    
    
    
    private func createToolBar() -> UIView {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title:"Готово", style: .done, target: self,action: #selector(didTapDone))
        let downButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(didTapDown))
        let upButton = UIBarButtonItem(title:"", style: .plain, target: self, action: #selector(didTapUp))
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 14
        doneButton.tintColor = .systemIndigo
        downButton.tintColor = .systemIndigo
        downButton.image = UIImage(systemName: "arrow.down")
        upButton.tintColor = .systemIndigo
        upButton.image = UIImage(systemName: "arrow.up")
        keyboardToolbar.items = [downButton, space, upButton, flexBarButton, doneButton]
        
        return keyboardToolbar
    }
    
    
    private func addToolBar(to textFields: UITextField...) {
        let keyboardToolbar = createToolBar()
        textFields.forEach { textField in
            textField.inputAccessoryView = keyboardToolbar
        }
    }
    
    
    func changedResponderForUpButton() {
        
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
    
    func changedResponderForDownButton() {
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
        } else {
            waterRatioTF.text = viewModel.listOfWaterRatio[row]
        }
    }
}

extension AddingNewProductViewController {
    
    
    
    
    
    
}
