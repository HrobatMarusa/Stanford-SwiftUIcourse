//
//  Array+Identifiable.swift
//  MemoryGame
//
//  Created by Marusa Hrobat on 28/11/2020.
//

import Foundation

extension Array where Element: Identifiable { //eg. Item
    func firstIndex(matching: Element) -> Int? { //type optional
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil // nil = not set value, return nothing
    }
}
