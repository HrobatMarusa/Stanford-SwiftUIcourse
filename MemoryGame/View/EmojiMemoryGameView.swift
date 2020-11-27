//
//  EmojiMemoryGameView.swift
//  MemoryGame
//
//  Created by Marusa Hrobat on 20/11/2020.
//
// This is the VIEW

import SwiftUI


struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame //@ObservedObject - redraw the view whenever viewModel var changes
    
    var body: some View {
        HStack{  //is a container view (also VStack, ZStack)
            ForEach(viewModel.cards){ card in
                CardView(card: card).onTapGesture{
                    viewModel.choose(card:card)
                }
            }
        }
            .padding()
            .foregroundColor(Color.orange)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {
        ZStack{
            if card.isFaceUp {
            RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
            RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Text(card.content)
        } else {
            RoundedRectangle(cornerRadius: cornerRadius).fill()
        }
        }
        .font(Font.system(size: fontSize(for: size)))
    }
    
    //MARK: - Drawing constants
    let cornerRadius: CGFloat = 10
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height)*fontScaleFactor
    }
}

//for the preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

