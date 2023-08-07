//
//  End7.swift
//  Squiggles
//
//  Created by Alex Resnik on 5/1/23.
//

import SwiftUI

struct End7: View {
    
    @StateObject private var viewModel = Model7()
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

extension End7 {
    private var endIphone: some View {
        VStack {
            Text("Game Over")
                .font(.system(size: 50))
                .foregroundColor(.white)
            Spacer()
            VStack(alignment: .leading) {
                Text("Moves: \(viewModel.moves) for 7")
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

extension End7 {
    private var endIpad: some View {
        VStack {
            Text("Game Over")
                .font(.system(size: 100))
                .foregroundColor(.white)
            Spacer()
            VStack(alignment: .leading) {
                Text("Moves: \(viewModel.moves) for 7")
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

struct End7_Previews: PreviewProvider {
    static var previews: some View {
        End7()
    }
}
