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
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent 
        var id: Int //need to have this because of the Identifiable constraint

    // MARK: - Bonus Time
    //if user matches a card before time passes (i.e. the pie countdown) then award bonus points
    
    var bonusTimeLimit: TimeInterval = 6
    
    //how long has a card been face up in total
    private var faceUpTime: TimeInterval {
        if let lastFaceUpDate = lastFaceUpDate {
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else {
            return pastFaceUpTime
        }
    }
       //the last time this card was turned face up
    var lastFaceUpDate: Date?
    //the accumulated time this card had been face up in the past (not including the current time)
    var pastFaceUpTime: TimeInterval = 0
    //how much time left before bonus time runs out
    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - faceUpTime)
    }
    //percentage of bonus time remaining
    var bonusRemaining: Double {
        (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
    }
    // whether the card was matched during the bonus time period
    var hasEarnedBonus: Bool {
        isMatched && bonusTimeRemaining > 0
    }

    // whether we are currently face up, unmatched and have not yet used up the bonus time
    var isConsumingBonusTime: Bool {
        isFaceUp && !isMatched && bonusTimeRemaining > 0
    }

    // called when the card transitions to face up
    private mutating func startUsingBonusTime() {
        if isConsumingBonusTime, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }

    //called when the card goes back face down (or gets matched)
    private mutating func stopUsingBonusTime() {
        pastFaceUpTime = faceUpTime
        lastFaceUpDate = nil
    }
}
}

