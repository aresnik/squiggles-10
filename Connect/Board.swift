//
//  Board.swift
//  ConnecttheDots
//
//  Created by Alex Resnik on 2/27/23.
//

import SwiftUI

private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
private let screenHeight: CGFloat = UIScreen.main.bounds.size.height
private var i: Int = 0
private var solution: Bool = false

struct Board: View {
    
    @StateObject private var viewModel = Model()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            grid
            if solution { middle }
            drawLine
            overlay
            button
        }
        .onAppear(perform: viewModel.randomize)
    }
}

extension Board {
    private var grid: some View {
        VStack(spacing: 0.0) {
            Spacer()
            VStack(spacing: 0.0) {
                ForEach(0..<10) { y in
                    HStack(spacing: 0.0) {
                        ForEach(0..<10) { x in
                            ZStack {
                                Rectangle()
                                    .stroke(.white)
                                let i = x + y*10
                                let dot = viewModel.dots.first { $0.dot == i }
                                Circle()
                                    .fill(dot?.color ?? .clear)
                                    .frame(width: screenWidth/16)
                            }
                        }
                    }
                }
            }
            .frame(width: screenWidth, height: screenWidth)
            Spacer()
        }
    }
}
extension Board {
    private var middle: some View {
        ForEach(viewModel.flows, id: \.color) { flow in
            Path { path in
                path.move(to: position(at: flow.middle.first ?? 0))
                for i in 0..<flow.middle.count {
                    path.addLine(to: position(at: flow.middle[i]))
                }
            }
            .stroke(flow.color, lineWidth: screenWidth/40)
            .offset(CGSize(width: screenWidth/20, height: screenWidth/2.44))
        }
    }
    
    // Convert index to position
    func position(at index: Int) -> CGPoint {
        let row = index / 10
        let col = index % 10
        return CGPoint(x: CGFloat(col) * screenWidth/10, y: CGFloat(row) * screenWidth/10)
    }
}

extension Board {
    private var drawLine: some View {
        ForEach(viewModel.lines, id: \.color) { line in
            Path { path in
                path.move(to: position(at: line.segment.first ?? 0))
                for i in 0..<line.segment.count {
                    path.addLine(to: position(at: line.segment[i]))
                }
            }
            .stroke(line.color, lineWidth: screenWidth/40)
            .offset(CGSize(width: screenWidth/20, height: screenWidth/2.44))
        }
    }
}

extension Board {
    var overlay: some View {
        VStack(spacing: 0.0) {
            Spacer()
            VStack(spacing: 0.0) {
                ForEach(0..<10) { y in
                    HStack(spacing: 0.0) {
                        ForEach(0..<10) { x in
                            Rectangle()
                                .fill(.clear)
                                .contentShape(Rectangle())
                                .simultaneousGesture(TapGesture().onEnded({
                                    let dot = viewModel.dots.first { $0.dot == i }
                                    if dot?.color ?? .clear != .clear {
                                        viewModel.lines[viewModel.k].segment.removeAll()
                                    }
                                }))
                                .simultaneousGesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .named("overlay"))
                                    .onChanged { value in
                                        let x = Int(value.location.x/(screenWidth/10))
                                        let y = Int(value.location.y/(screenWidth/10))
                                        i = x + y*10
                                        if i < 0  { i = 0  }
                                        if i > 99 { i = 99 }
                                        viewModel.move(i: i)
                                    }
                                    .onEnded { _ in
//                                        if !viewModel.isPairConnected() {
//                                            viewModel.lines[viewModel.k].segment.removeAll()
//                                        }
                                    }
                                )
                        }
                    }
                }
            }
            .coordinateSpace(name: "overlay")
            .frame(width: screenWidth, height: screenWidth)
            Spacer()
        }
        
    }
}

extension Board {
    private var button: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.dots.removeAll()
                    for i in 0..<viewModel.lines.count {
                        viewModel.lines[i].segment.removeAll()
                    }
                    viewModel.randomize()
                    solution = false
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
                Button(action: {
                    solution = true
                    for i in 0..<viewModel.lines.count {
                        viewModel.lines[i].segment.removeAll()
                    }
                    viewModel.drawDots()
                }, label: {
                    Text("Solution")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Capsule()
                                .stroke(Color.white, lineWidth: 2.0)
                        )
                })
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
