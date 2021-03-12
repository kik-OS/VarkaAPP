//
//  PopOverMenuTableViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 10.03.2021.
//

import Foundation

let arrayOfCategories = ["Макароны", "Рис", "Гречка", "Крупа", "Пельмени", "Вареники"]

protocol PopOverMenuTableViewModelProtocol {
    func numberOfRows() -> Int
    func selectedCategory(at indexPath: IndexPath) -> String
    
}

class PopOverMenuTableViewModel: PopOverMenuTableViewModelProtocol {
    func selectedCategory(at indexPath: IndexPath) -> String {
        arrayOfCategories[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        arrayOfCategories.count
    }
    
    
    
}
