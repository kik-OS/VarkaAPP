//
//  AddNewProductViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//



import Foundation

enum IncorrectMessages: String {
    case incorrectTitle = "Что-то не так с названием, проверьте его"
    case incorrectCookingTime = "Нам кажется, или время пригтовления выбрано не верно"
    case incorrectCategory = "Пожалуйста, выберите категорию продукта"
}

protocol AddNewProductViewModelProtocol {
    var textFromTitleProductTF: String? { get set }
    var textFromCookingTimeTF: String? { get set }
    var categorySelected: Bool { get set }
    func validation() -> Bool
    var incorrectMessage: String { get }
    
}

final class AddNewProductViewModel: AddNewProductViewModelProtocol {
    var incorrectMessage: String = ""
    
   
    
    // MARK: - Properties
    
    var textFromTitleProductTF: String?
    var textFromCookingTimeTF: String?
    var categorySelected: Bool = false
    
    
    // MARK: - Methods
    
    func validation() -> Bool {
        guard categorySelected else {
            incorrectMessage = IncorrectMessages.incorrectCategory.rawValue
            return false }
        guard let titleText = textFromTitleProductTF else {
            incorrectMessage = IncorrectMessages.incorrectTitle.rawValue
            return false}
        guard let cookingTime = textFromCookingTimeTF else {
            incorrectMessage = IncorrectMessages.incorrectCookingTime.rawValue
            return false}
        guard let intCookingTime = Int(cookingTime) else {
            incorrectMessage = IncorrectMessages.incorrectCookingTime.rawValue
            return false}
        guard titleText.count >= 2 else {
            incorrectMessage = IncorrectMessages.incorrectTitle.rawValue
            return false}
        guard intCookingTime > 0 else {
            incorrectMessage = IncorrectMessages.incorrectCookingTime.rawValue
            return false }
        return true
    }
    
    
}

protocol AddNewProductViewControllerDelegate {
    func getSelectedItemFromPopOver(item: String)
}



