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
    
    @StateObject private var viewModel = Model()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            grid
            middle
            overlay
        }.onAppear(perform: viewModel.start)
    }
}

extension Board {
    private var grid: some View {
        VStack(spacing: 0.0) {
            Spacer()
            ForEach(0..<10) { y in
                HStack(spacing: 0.0) {
                    ForEach(0..<10) { x in
                        ZStack {
                            let i = x + y*10
                            Rectangle()
                                .stroke(.white)
                                .scaledToFit()
                            Circle()
                                .fill(viewModel.end[i])
                                .frame(width: screenWidth/16)
                            
                        }
                    }
                }
            }
            Spacer()
        }
    }
}
extension Board {
    private var middle: some View {
        VStack(spacing: 0.0) {
            Spacer()
            ForEach(0..<10) { y in
                HStack(spacing: 0.0) {
                    ForEach(0..<10) { x in
                        ZStack {
                            let i = x + y*10
                            Rectangle()
                                .stroke(.clear)
                                .frame(width: screenWidth/10, height: screenWidth/10)
                            Rectangle()
                                .fill(viewModel.middle[i])
                                .frame(width: screenWidth/30, height: screenWidth/30)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

extension Board {
    var overlay: some View {
        VStack(spacing: 0.0) {
            Spacer()
            ForEach(0..<10) { _ in
                HStack(spacing: 0.0) {
                    ForEach(0..<10) { _ in
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .gesture(DragGesture(coordinateSpace: .named("overlay"))
                                .onChanged { value in
                                    let x = Int(value.location.x/(screenWidth/10))
                                    let y = Int(value.location.y/(screenWidth/10))
                                    var i = x + y*10
                                    if i < 0  { i = 0  }
                                    if i > 99 { i = 99 }
                                    viewModel.move(i: i)
                                }
                            )
                    }
                }
            }
            Spacer()
        }
        .coordinateSpace(name: "overlay")
        .frame(width: screenWidth, height: screenWidth)
    }
}
struct Board_Previews: PreviewProvider {
    static var previews: some View {
        Board()
    }
}
