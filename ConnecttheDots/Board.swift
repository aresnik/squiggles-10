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
            horozontal
            vertical
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
                                .frame(width: screenWidth/18)
                            Circle()
                                .fill(viewModel.corner[i])
                                .frame(width: screenWidth/30)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}
extension Board {
    private var horozontal: some View {
        VStack(spacing: 0.0) {
            Spacer()
            ForEach(0..<10) { y in
                HStack(spacing: 0.0) {
                    ForEach(0..<9) { x in
                        ZStack {
                            let i = x + y*9
                            Rectangle()
                                .stroke(.clear)
                                .frame(width: screenWidth/10, height: screenWidth/10)
                                
                            Rectangle()
                                .fill(viewModel.horizontal[i])
                                .frame(width: screenWidth/10, height: screenWidth/30)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}
extension Board {
    var vertical: some View {
        VStack(spacing: 0.0) {
            Spacer()
            ForEach(0..<9) { y in
                HStack(spacing: 0.0) {
                    ForEach(0..<10) { x in
                        ZStack {
                            let i = x + y*10
                            Rectangle()
                                .stroke(.clear)
                                .scaledToFit()
                            Rectangle()
                                .fill(viewModel.verticle[i])
                                .frame(width: screenWidth/30, height: screenWidth/10)
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
            ForEach(0..<10) { y in
                HStack(spacing: 0.0) {
                    ForEach(0..<10) { x in
                        var w = 0; var h = 0
                        Rectangle()
                            .fill(.clear)
                            .scaledToFit()
                            .contentShape(Rectangle())
                            .gesture(DragGesture()
                                .onChanged { value in
                                    w = x + Int(value.translation.width/(screenWidth/10))
                                    h = y + Int(value.translation.height/(screenWidth/10))
                                    var i = w + h*10
                                    if i > 79 { i = 79 }
                                    viewModel.move(i: i)
                                }
                            )
                    }
                }
            }
            Spacer()
        }
    }
}
struct Board_Previews: PreviewProvider {
    static var previews: some View {
        Board()
    }
}
