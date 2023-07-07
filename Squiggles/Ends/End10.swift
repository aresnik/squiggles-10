//
//  End10.swift
//  Squiggles
//
//  Created by Alex Resnik on 5/1/23.
//

import SwiftUI

struct End10: View {
    
    @StateObject private var viewModel = Model10()
    @State var isActive : Bool = false
    
    var body: some View {
        if isActive {
            Board6()
        } else {
            Color.black
                .ignoresSafeArea()
                .overlay(
                VStack {
                    Text("Game Over")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Moves: \(viewModel.moves) for 10")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .frame(alignment: .leading)
                            .padding()
                        Text("Perfect Games: \(viewModel.perfectGames)")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .frame(alignment: .leading)
                            .padding()
                        Text("Perfect Streak: \(viewModel.perfectStreak)")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .frame(alignment: .leading)
                            .padding()
                        Text("Longest Streak: \(viewModel.longestStreak)")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .frame(alignment: .leading)
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        isActive = true
                    }, label: {
                        Text("Play Again")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Capsule()
                                .stroke(Color.white, lineWidth: 2.0)
                            )
                    })
                    Spacer()
                } .onAppear(perform: viewModel.load)
            )
        }
    }
}

struct End10_Previews: PreviewProvider {
    static var previews: some View {
        End10()
    }
}
