//
//  MemoryGameModel.swift
//  MemoryGame
//
//  Created by Marusa Hrobat on 20/11/2020.
//

//this is the MODEL of the MVVM

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    func choose(card: Card){
        print("card chosen: \(card)")
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int)->CardContent){
        cards = Array<Card>() //empty array of cards
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2)) //card 1 of the pair
            cards.append(Card(content: content, id: pairIndex*2+1)) //card 2 of the pair
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent 
        var id: Int //need to have this because of the Identifiable constraint
    }
}
