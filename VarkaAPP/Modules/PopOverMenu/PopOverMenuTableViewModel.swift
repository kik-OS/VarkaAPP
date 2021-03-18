//
//  PopOverMenuTableViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 10.03.2021.
//

import Foundation

protocol PopOverMenuTableViewModelProtocol {
    var categories : [Category] { get }
    func numberOfRows() -> Int
    func selectedCategory(at indexPath: IndexPath) -> String
    init(categories: [Category])
    
}

final class PopOverMenuTableViewModel: PopOverMenuTableViewModelProtocol {
    
    required init(categories: [Category]) {
        self.categories = categories
    }
    
    var categories: [Category] = []
    
    func selectedCategory(at indexPath: IndexPath) -> String {
        categories[indexPath.row].name
    }
    
    func numberOfRows() -> Int {
        categories.count
    }
}
