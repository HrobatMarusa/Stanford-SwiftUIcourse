//
//  Grid.swift
//  MemoryGame
//
//  Created by Marusa Hrobat on 28/11/2020.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View { //takes two arguments, item (card) and ItemView, constraining arguments to be of a specific type
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView  //function that takes the item and returns some item view

    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) { //this func escapes the init because it's in the var above
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            body(for: item, in: layout)
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)! //unwrapping the optional (get the value from the set state)
        return viewForItem(item) //this has to be a view
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
            //index will never be nil
    }
}




