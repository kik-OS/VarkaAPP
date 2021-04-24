//
//  FirebaseServiceError.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 17.03.2021.
//

import Foundation

enum FirebaseServiceError: Error, LocalizedError {
    case productNotFound
    case modelInitializingError
    
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "По данному коду продукт в базе не найден"
        case .modelInitializingError:
            return "Ошибка при инициализации продукта"
        }
    }
}
