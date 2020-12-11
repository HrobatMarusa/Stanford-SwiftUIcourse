//
//  MemoryGameModel.swift
//  MemoryGame
//
//  Created by Marusa Hrobat on 20/11/2020.
//

//this is the MODEL of the MVVM

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable { //when card content can be equatable (==)
    private(set) var cards: Array<Card> //only the memory game model can set/change attributes of this var (but anyone can read)
    
    private var indexOfTheOneFaceUpCard: Int? { //computed value, optionals get initialized to nil (not set)
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card){ //mutating func because it's changing the self
        print("card chosen: \(card)")
        if let chosenIndex = cards.firstIndex(matching: card),!cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched { //if cards.firstIndex(matching: card) is not nill
            
            if let potentialMatchIndex = indexOfTheOneFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneFaceUpCard = chosenIndex
                }
            }
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
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent 
        var id: Int //need to have this because of the Identifiable constraint
    }
}
