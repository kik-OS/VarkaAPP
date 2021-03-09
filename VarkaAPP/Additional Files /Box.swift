//
//  Box.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 09.03.2021.
//

final class Box<T> {
    
    typealias Listener = ((T) -> Void)
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    var listener: Listener?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
}
