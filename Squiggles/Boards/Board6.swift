//
//  Board6.swift
//  Squiggles
//
//  Created by Alex Resnik on 2/27/23.
//

import SwiftUI

private let screenWidth: CGFloat = UIScreen.main.bounds.width
private var solution: Bool = false

struct Board6: View {
    
    @StateObject private var viewModel = Model6()
    
    var body: some View {
        ZStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                grid
                if solution { middle }
                if !solution { drawLine }
                overlay
                button
                label
            }
            .onAppear(perform: viewModel.randomize)
            .allowsHitTesting(!viewModel.solved)
            .blur(radius: viewModel.solved ? 2 : 0)
            if viewModel.solved { Alert6() }
        }
    }
}

extension Board6 {
    private var grid: some View {
        VStack(spacing: 0.0) {
            Spacer()
            VStack(spacing: 0.0) {
                ForEach(0..<6) { y in
                    HStack(spacing: 0.0) {
                        ForEach(0..<6) { x in
                            ZStack {
                                Rectangle()
                                    .stroke(.white)
                                let i = x + y*6
                                let dot = viewModel.dots.first { $0.dot == i }
                                Circle()
                                    .fill(dot?.color ?? .clear)
                                    .frame(width: screenWidth/8)
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
extension Board6 {
    private var middle: some View {
        GeometryReader { geo in
            ForEach(viewModel.squiggles, id: \.color) { squiggle in
                Path { path in
                    path.move(to: position(at: squiggle.middle.first ?? 0))
                    for i in 0..<squiggle.middle.count {
                        path.addLine(to: position(at: squiggle.middle[i]))
                    }
                }
                .stroke(squiggle.color, lineWidth: screenWidth/24)
                .offset(CGSize(width: geo.size.width/12, height: (geo.size.height - geo.size.width)/2 +
                               geo.size.width/12))
            }
        }
    }
    
    // Convert index to position
    func position(at index: Int) -> CGPoint {
        let row = index / 6
        let col = index % 6
        return CGPoint(x: CGFloat(col) * screenWidth/6, y: CGFloat(row) * screenWidth/6)
    }
}

extension Board6 {
    private var drawLine: some View {
        GeometryReader { geo in
            ForEach(viewModel.lines, id: \.color) { line in
                Path { path in
                    path.move(to: position(at: line.segment.first ?? 0))
                    for i in 0..<line.segment.count {
                        path.addLine(to: position(at: line.segment[i]))
                    }
                }
                .stroke(line.color, lineWidth: screenWidth/24)
                .offset(CGSize(width: geo.size.width/12, height: (geo.size.height - geo.size.width)/2 +
                               geo.size.width/12))
            }
        }
    }
}

extension Board6 {
    var overlay: some View {
        VStack(spacing: 0.0) {
            Spacer()
            VStack(spacing: 0.0) {
                ForEach(0..<6) { h in
                    HStack(spacing: 0.0) {
                        ForEach(0..<6) { w in
                            Rectangle()
                                .fill(.clear)
                                .contentShape(Rectangle())
                                .simultaneousGesture(TapGesture().onEnded({
                                    let j = w + h*6
                                    viewModel.deleteLine(i: j)
                                }))
                                .simultaneousGesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .named("overlay"))
                                    .onChanged { value in
                                        let j = w + h*6
                                        let x = Int(value.location.x/(screenWidth/6))
                                        let y = Int(value.location.y/(screenWidth/6))
                                        var i = x + y*6
                                        if i < 0  { i = 0  }
                                        if i > 35 { i = 35 }
                                        viewModel.start(i: j)
                                        if !solution {
                                            viewModel.move(i: i)
                                        }
                                        viewModel.countMoves()
                                    }
                                    .onEnded { _ in
                                        if !viewModel.isPairConnected() {
                                            viewModel.lines[viewModel.k].segment.removeAll()
                                        }
                                        viewModel.isSolved()
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

extension Board6 {
    private var button: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    solution.toggle()
                    viewModel.drawDots()
                }, label: {
                if !solution {
                    Text("Show Solution")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Capsule()
                                .stroke(Color.white, lineWidth: 2.0)
                        )
                } else {
                    Text("Hide Solution")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Capsule()
                                .stroke(Color.white, lineWidth: 2.0)
                        )
                }
                })
            }.padding(.top, 15)
            Spacer()
        }
    }
}

extension Board6 {
    private var label: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                Text("Moves: \(viewModel.moves) for 6")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                Spacer()
            }.offset(CGSize(width: 0, height: (geo.size.height - geo.size.width)/2 - 35))
        }
    }
}


struct Board6_Previews: PreviewProvider {
    static var previews: some View {
        Board6()
    }
}
