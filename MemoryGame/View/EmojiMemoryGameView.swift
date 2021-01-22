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
        VStack {
        Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration:0.75)){
                    viewModel.choose(card:card)
                }
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(Color.orange)
            Button(action: {
                    withAnimation(.easeInOut){
                        self.viewModel.resetGame()
                    }
                }, label: { Text("New Game")}) //red because it should be localized (translated into other languages)
            .foregroundColor(.white)
                .padding()
                .background(Color.orange)
                .cornerRadius(8)
    }
}
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
        ZStack{
            Group {
                if card.isConsumingBonusTime {
                    Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                        .onAppear {
                            startBonusTimeAnimation()
                        }
                } else {
                    Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                }
            }.padding(5).opacity(0.4)
            .transition(.identity)
            
            Text(card.content).font(Font.system(size: fontSize(for: size)))
                .rotationEffect(Angle.degrees(card.isMatched ? 360 :0))
                .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default) //implicit animation
        }
        .cardify(isFaceUp: card.isFaceUp)
        .transition(AnyTransition.scale) //scale down when matched, scaled up when new game starts
    }
    }
    
    //MARK: - Drawing constants
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height)*0.7
    }
}

//for the preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}

