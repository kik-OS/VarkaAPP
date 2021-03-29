//
//  DateFormatter+Extension.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 11.03.2021.
//

import Foundation

extension DateFormatter {
    
    static let firebaseDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
}
