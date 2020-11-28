//
//  Array+Only.swift
//  MemoryGame
//
//  Created by Marusa Hrobat on 28/11/2020.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first: nil //if count = 1 return the first item in the array, otherwise return nil
    }
}
