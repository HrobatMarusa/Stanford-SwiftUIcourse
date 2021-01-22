//
//  EmojiMemoryGame.swift
//  MemoryGame
//
//  Created by Marusa Hrobat on 20/11/2020.
// This is the ViewModel

import SwiftUI


class EmojiMemoryGame: ObservableObject {  //ObservableObject only works for classes!
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame() //@Published is a property wrapper, change in the model is broadcast objectWillChange.send()
        //access control (private) = how other structs access vars
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃", "🕷"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) {pairIndex in
            return emojis[pairIndex]
        }
    }
    
    
    // MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card>{
        return model.cards
    }
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame(){
        model = EmojiMemoryGame.createMemoryGame()
    }
}

