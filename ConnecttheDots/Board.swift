//
//  Board.swift
//  ConnecttheDots
//
//  Created by Alex Resnik on 2/27/23.
//

import SwiftUI

private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
private let screenHeight: CGFloat = UIScreen.main.bounds.size.height

struct Board: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Grid()
            Horozontal()
            Vertical()
        }
    }
}

struct Grid: View {
    
    @StateObject private var viewModel = Model()
    
    var body: some View {
        VStack(spacing: 0.0) {
            Spacer()
            ForEach(0..<10) { y in
                HStack(spacing: 0.0) {
                    ForEach(0..<10) { x in
                        ZStack {
                            let i = x + y*10
                            Rectangle()
                                .stroke(Color.white)
                                .scaledToFit()
                            Circle()
                                .fill(viewModel.end[i])
                                .frame(width: screenWidth/18)
                            Circle()
                                .fill(viewModel.corner[i])
                                .frame(width: screenWidth/30)
                        }
                    }
                }
            }
            Spacer()
        }.onAppear(perform: viewModel.start)
    }
}
struct Horozontal: View {
    
    @StateObject private var viewModel = Model()
    
    var body: some View {
        VStack(spacing: 0.0) {
            Spacer()
            ForEach(0..<10) { y in
                HStack(spacing: 0.0) {
                    ForEach(0..<9) { x in
                        ZStack {
                            let i = x + y*9
                            Rectangle()
                                .stroke(Color.clear)
                                .frame(width: screenWidth/10, height: screenWidth/10)
                                
                            Rectangle()
                                .fill(viewModel.horizontal[i])
                                .frame(width: screenWidth/10, height: screenWidth/30)
                        }
                    }
                }
            }
            Spacer()
        }.onAppear(perform: viewModel.start)
    }
}
struct Vertical: View {
    
    @StateObject private var viewModel = Model()
    
    var body: some View {
        VStack(spacing: 0.0) {
            Spacer()
            ForEach(0..<9) { y in
                HStack(spacing: 0.0) {
                    ForEach(0..<10) { x in
                        ZStack {
                            let i = x + y*10
                            Rectangle()
                                .stroke(Color.clear)
                                .scaledToFit()
                            Rectangle()
                                .fill(viewModel.verticle[i])
                                .frame(width: screenWidth/30, height: screenWidth/10)
                        }
                    }
                }
            }
            Spacer()
        }.onAppear(perform: viewModel.start)
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        Board()
    }
}
