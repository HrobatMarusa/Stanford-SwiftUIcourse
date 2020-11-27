//
//  MemoryGameApp.swift
//  MemoryGame
//
//  Created by Marusa Hrobat on 20/11/2020.
//

import SwiftUI

@main
struct MemoryGameApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
}
