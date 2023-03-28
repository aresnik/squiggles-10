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
//            middle
            drawLines
            overlay
        }.onAppear(perform: viewModel.randomize)
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
                            Rectangle()
                                .stroke(.white)
                                .scaledToFit()
                            let dot = viewModel.dots.first { $0.x == x && $0.y == y }
                            Circle()
                                .fill(dot?.color ?? .clear)
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
        ForEach(viewModel.flows, id: \.color) { flow in
            Path { path in
                path.move(to: position(at: flow.middles.first ?? 0))
                for i in 0..<flow.middles.count {
                    path.addLine(to: position(at: flow.middles[i]))
                }
            }
            .stroke(flow.color, lineWidth: 8)
            .offset(CGSize(width: 20, height: 155))
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
    private var drawLines: some View {
        ForEach(viewModel.lines, id: \.color) { line in
            Path { path in
                path.move(to: CGPoint(x: line.start.x, y: line.start.y))
                path.addLine(to: CGPoint(x: line.end.x, y: line.end.y))
            }
            .stroke(line.color, lineWidth: 8)
            .offset(CGSize(width: 20, height: 155))
        }
    }
}


extension Board {
    var overlay: some View {
        VStack(spacing: 0.0) {
            Color.clear
                .background(grid)
                .gesture(
                    DragGesture(minimumDistance: 0.0, coordinateSpace: .named("overlay"))
                        .onChanged { value in
                            // Find the dot that was tapped
                            let x = Int(value.location.x/(screenWidth/10))
                            let y = Int(value.location.y/(screenWidth/10))
                            guard let dot = viewModel.dots.first(where: { $0.x == x && $0.y == y }) else {
                                return
                            }

                            // Check if there is already a line starting or ending at this dot
                            if viewModel.lines.contains(where: { $0.start == dot || $0.end == dot }) {
                                return
                            }
                            
                            // Find the line that is currently being drawn
                            guard var line = viewModel.lines.last else {
                                // Create a new line starting at this dot
                                viewModel.lines.append(Model.Line(color: dot.color, start: dot, end: dot))
                                return
                            }

                            // Update the end point of the line to the current dot
                            line.end = dot
                            
                            // Update the lines array with the new line
                            viewModel.lines[viewModel.lines.count - 1] = line
                        }

                        .onEnded { value in
                            // Find the dot that the touch ended on
                            let x = Int(value.location.x/(screenWidth/10))
                            let y = Int(value.location.y/(screenWidth/10))
                            _ = viewModel.dots.first(where: { $0.x == x && $0.y == y })
                        }
                )
                .coordinateSpace(name: "overlay")
        }
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        Board()
    }
}
