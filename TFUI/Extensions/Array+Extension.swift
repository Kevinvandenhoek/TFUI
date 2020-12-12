//
//  Array+Extension.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

extension Array {
    
    /// Returns value from given index. If out of bounds, return nil
    subscript (safe index: Int) -> Element? {
        return index < count && index >= 0 ? self[index] : nil
    }
}
