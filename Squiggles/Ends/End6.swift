//
//  End6.swift
//  Squiggles
//
//  Created by Alex Resnik on 5/1/23.
//

import SwiftUI
import GameKit

struct End6: View {
    
    @StateObject private var viewModel = Model6()
    @State var isActive : Bool = false
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        if isActive {
            Board6()
        } else {
            Color.black
                .ignoresSafeArea()
                .overlay(
                    VStack {
                        if idiom == .phone { endIphone }
                        if idiom == .pad { endIpad }
                    }
            )
        }
    }
}

extension End6 {
    private var endIphone: some View {
        VStack {
            Text("Game Over")
                .font(.system(size: 50))
                .foregroundColor(.white)
            Spacer()
            VStack(alignment: .leading) {
                Text("Time: \(viewModel.timeCurrent)")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .frame(alignment: .leading)
                    .padding()
                Text("Moves: \(viewModel.moves) for 6")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .frame(alignment: .leading)
                    .padding()
                Text("Best Time: \(viewModel.timeBest)")
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
    }
}

extension End6 {
    private var endIpad: some View {
        VStack {
            Text("Game Over")
                .font(.system(size: 100))
                .foregroundColor(.white)
            Spacer()
            VStack(alignment: .leading) {
                Text("Time: \(viewModel.timeCurrent)")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .frame(alignment: .leading)
                    .padding()
                Text("Moves: \(viewModel.moves) for 6")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .frame(alignment: .leading)
                    .padding()
                Text("Best Time: \(viewModel.timeBest)")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .frame(alignment: .leading)
                    .padding()
                Text("Perfect Games: \(viewModel.perfectGames)")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .frame(alignment: .leading)
                    .padding()
                Text("Perfect Streak: \(viewModel.perfectStreak)")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .frame(alignment: .leading)
                    .padding()
                Text("Longest Streak: \(viewModel.longestStreak)")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .frame(alignment: .leading)
                    .padding()
            }
            Spacer()
            Button(action: {
                isActive = true
            }, label: {
                Text("Play Again")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .padding(25)
                    .background(
                        Capsule()
                        .stroke(Color.white, lineWidth: 4.0)
                    )
            })
            Spacer()
        } .onAppear(perform: viewModel.load)
    }
}

struct End6_Previews: PreviewProvider {
    static var previews: some View {
        End6()
    }
}
