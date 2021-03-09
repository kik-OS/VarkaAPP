//
//  AddNewProductViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//

import UIKit


protocol AddNewProductViewControllerDelegate {
    func getSelectedItemFromPopOver(item: String)
}

class AddNewProductViewController: UIViewController {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var titleOfProduct: UITextField!
    @IBOutlet weak var cookingTime: UITextField!
    @IBOutlet weak var producer: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    @IBAction func titleProductEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func timeOfCookingEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let code = "4603726592574"
        
        guard let category = categoryButton.title(for: .normal),
              let title = titleOfProduct.text,
              let cookingTime = Int(cookingTime.text!)
              else { return }
        let producerText = producer.text!
        let weightText = Int(weight.text!)
        
        let product = Product(code: code, title: title, producer: producerText, category: category, weight: weightText, cookingTime: cookingTime, intoBoilingWater: true, needStirring: true)
        
        FirebaseService().saveProduct(product)
    
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updateSaveButtonState()
        setupGestures()
    }
    
    
    private func updateSaveButtonState() {
        let titleOfProductText = titleOfProduct.text ?? ""
        let cookingTimeText = cookingTime.text ?? ""
        saveButton.isEnabled = !titleOfProductText.isEmpty && !cookingTimeText.isEmpty
    }
    
    
    
    
    //MARK: ADD POPOVER MENU
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.numberOfTouchesRequired = 1
        categoryButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapped() {
        guard let popVC = storyboard?.instantiateViewController(identifier: "popVC") as? PopOverMenuTableTableViewController else { return }
        popVC.delegate = self
        popVC.modalPresentationStyle = .popover
        
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.categoryButton
        popOverVC?.sourceRect = CGRect(x: self.categoryButton.bounds.midX / 2,
                                       y: self.categoryButton.bounds.midY,
                                       width: 0,
                                       height: 0)
        popVC.preferredContentSize = CGSize(width: 150, height: 150)
        self.present(popVC, animated: true)
    }
}





extension AddNewProductViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension AddNewProductViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension AddNewProductViewController: AddNewProductViewControllerDelegate {
    func getSelectedItemFromPopOver(item: String) {
        let selectedItem = item
        categoryButton.setTitle(selectedItem, for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
    }
}
