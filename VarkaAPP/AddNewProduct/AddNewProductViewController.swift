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
        print("!!!!!!!!!!!!!!!!!!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        updateSaveButtonState()
        setupGestures()
    }
    
    
    
    
//    @objc private func keyBoardDidShow(notification: Notification) {
//        guard let userInfo = notification.userInfo else { return }
//        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
//
//        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
//    }
//
//    @objc private func keyBoardDidHide() {
//        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
//    }
    
    
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
        let selectedItem = "  " + item
        categoryButton.setTitle(selectedItem, for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
    }
}
