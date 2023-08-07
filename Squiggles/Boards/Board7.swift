//
//  Board7.swift
//  Squiggles
//
//  Created by Alex Resnik on 2/27/23.
//

import SwiftUI

private let screenWidth: CGFloat = UIScreen.main.bounds.width
private var solution: Bool = false

struct Board7: View {
    
    @StateObject private var viewModel = Model7()
    @State var GoToSelect = false
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        if GoToSelect {
            Select()
        } else {
            ZStack {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    grid
                    if solution { middle }
                    if !solution { drawLine }
                    overlay
                    if idiom == .phone { buttonIphone }
                    if idiom == .pad { buttonIpad }
                    if idiom == .phone { labelIphone }
                    if idiom == .pad { labelIpad }
                }
                .onAppear(perform: viewModel.randomize)
                .allowsHitTesting(!viewModel.solved)
                .blur(radius: viewModel.solved ? 2 : 0)
                if viewModel.solved { Alert7() }
            }
        }
    }
}

extension Board7 {
    private var grid: some View {
        VStack(spacing: 0.0) {
            Spacer()
            VStack(spacing: 0.0) {
                ForEach(0..<7) { y in
                    HStack(spacing: 0.0) {
                        ForEach(0..<7) { x in
                            ZStack {
                                Rectangle()
                                    .stroke(.white)
                                let i = x + y*7
                                let dot = viewModel.dots.first { $0.dot == i }
                                Circle()
                                    .fill(dot?.color ?? .clear)
                                    .frame(width: screenWidth/10)
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
extension Board7 {
    private var middle: some View {
        GeometryReader { geo in
            ForEach(viewModel.squiggles, id: \.color) { squiggle in
                Path { path in
                    path.move(to: position(at: squiggle.middle.first ?? 0))
                    for i in 0..<squiggle.middle.count {
                        path.addLine(to: position(at: squiggle.middle[i]))
                    }
                }
                .stroke(squiggle.color, lineWidth: screenWidth/28)
                .offset(CGSize(width: geo.size.width/14, height: (geo.size.height - geo.size.width)/2 +
                               geo.size.width/14))
            }
        }
    }
    
    // Convert index to position
    func position(at index: Int) -> CGPoint {
        let row = index / 7
        let col = index % 7
        return CGPoint(x: CGFloat(col) * screenWidth/7, y: CGFloat(row) * screenWidth/7)
    }
}

extension Board7 {
    private var drawLine: some View {
        GeometryReader { geo in
            ForEach(viewModel.lines, id: \.color) { line in
                Path { path in
                    path.move(to: position(at: line.segment.first ?? 0))
                    for i in 0..<line.segment.count {
                        path.addLine(to: position(at: line.segment[i]))
                    }
                }
                .stroke(line.color, lineWidth: screenWidth/28)
                .offset(CGSize(width: geo.size.width/14, height: (geo.size.height - geo.size.width)/2 +
                               geo.size.width/14))
            }
        }
    }
}

extension Board7 {
    var overlay: some View {
        VStack(spacing: 0.0) {
            Spacer()
            VStack(spacing: 0.0) {
                ForEach(0..<7) { h in
                    HStack(spacing: 0.0) {
                        ForEach(0..<7) { w in
                            Rectangle()
                                .fill(.clear)
                                .contentShape(Rectangle())
                                .simultaneousGesture(TapGesture().onEnded({
                                    let j = w + h*7
                                    viewModel.deleteLine(i: j)
                                }))
                                .simultaneousGesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .named("overlay"))
                                    .onChanged { value in
                                        let j = w + h*7
                                        let x = Int(value.location.x/(screenWidth/7))
                                        let y = Int(value.location.y/(screenWidth/7))
                                        var i = x + y*7
                                        if i < 0  { i = 0  }
                                        if i > 48 { i = 48 }
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

extension Board7 {
    private var buttonIphone: some View {
        VStack {
            HStack {
                Button(action: {
                    GoToSelect = true
                }, label: {
                    Text("Select Board")
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

extension Board7 {
    private var buttonIpad: some View {
        VStack {
            HStack {
                Button(action: {
                    GoToSelect = true
                }, label: {
                    Text("Select Board")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                        .padding(25)
                        .background(
                            Capsule()
                                .stroke(Color.white, lineWidth: 4.0)
                        )
                })
                Spacer()
                Button(action: {
                    solution.toggle()
                    viewModel.drawDots()
                }, label: {
                if !solution {
                    Text("Show Solution")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                        .padding(25)
                        .background(
                            Capsule()
                                .stroke(Color.white, lineWidth: 4.0)
                        )
                } else {
                    Text("Hide Solution")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                        .padding(25)
                        .background(
                            Capsule()
                                .stroke(Color.white, lineWidth: 4.0)
                        )
                }
                })
            }.padding(.top, 15)
            Spacer()
        }
    }
}

extension Board7 {
    private var labelIphone: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                Text("Moves: \(viewModel.moves) for 7")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                Spacer()
            }.offset(CGSize(width: 0, height: (geo.size.height - geo.size.width)/2 - 35))
        }
    }
}

extension Board7 {
    private var labelIpad: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                Text("Moves: \(viewModel.moves) for 7")
                    .foregroundColor(.white)
                    .font(.system(size: 35))
                Spacer()
            }.offset(CGSize(width: 0, height: (geo.size.height - geo.size.width)/2 - 40))
        }
    }
}


struct Board7_Previews: PreviewProvider {
    static var previews: some View {
        Board7()
    }
}
