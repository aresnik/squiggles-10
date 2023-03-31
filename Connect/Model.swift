//
//  Model.swift
//  ConnecttheDots
//
//  Created by Alex Resnik on 2/27/23.
//

import Foundation
import SwiftUI

final class Model: ObservableObject {

    // Initial flows
    @Published var flows: [Flow] = [
        Flow(color: .red,    middle: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99]),
        Flow(color: .blue,   middle: [1, 11, 21, 31, 41, 51, 61, 71, 81]),
        Flow(color: .green,  middle: [2, 12, 22, 32, 42, 52, 62, 72, 82]),
        Flow(color: .orange, middle: [3, 13, 23, 33, 43, 53, 63, 73, 83]),
        Flow(color: .yellow, middle: [4, 14, 24, 34, 44, 54, 64, 74, 84]),
        Flow(color: .gray  , middle: [5, 15, 25, 35, 45, 55, 65, 75, 85]),
        Flow(color: .purple, middle: [6, 16, 26, 36, 46, 56, 66, 76, 86]),
        Flow(color: .brown,  middle: [7, 17, 27, 37, 47, 57, 67, 77, 87]),
        Flow(color: .cyan,   middle: [8, 18, 28, 38, 48, 58, 68, 78, 88]),
        Flow(color: .indigo, middle: [9, 19, 29, 39, 49, 59, 69, 79, 89]) ]
    @Published var lines: [Line] = [
        Line(color: .red,    segment: []),
        Line(color: .blue,   segment: []),
        Line(color: .green,  segment: []),
        Line(color: .orange, segment: []),
        Line(color: .yellow, segment: []),
        Line(color: .gray  , segment: []),
        Line(color: .purple, segment: []),
        Line(color: .brown,  segment: []),
        Line(color: .cyan,   segment: []),
        Line(color: .indigo, segment: []) ]
    @Published var dots: [Dot] = []
    @Published var endDrag: Bool = false
    private var color: [Color] = [
        .red, .blue, .green, .orange, .yellow, .gray, .purple, .brown, .cyan, .indigo ].shuffled()
    
    struct Flow {
        var color: Color
        var middle: [Int]
    }
    
    struct Line: Equatable {
        var color: Color
        var segment: [Int]
    }
    
    struct Dot: Equatable {
        var color: Color
        var dot: Int
    }
    
    func randomizecolors() {
        for i in 0..<flows.count {
            flows[i].color = color[i]
        }
    }
    
    func drawDots() {
        for i in 0..<flows.count {
            dots.append(Dot(color: color[i], dot: flows[i].middle.first ?? 0))
            dots.append(Dot(color: color[i], dot: flows[i].middle.last ?? 0))
        }
    }
    
    func randomize() {
        for _ in 0..<100 {
        let rnd: Int = Int.random(in: 0..<flows.count)
            for i in 0..<flows.count {
                if flows[rnd].middle.count > 3 {
                    if isNeighbor(end1: flows[rnd].middle.first ?? 0, end2: flows[i].middle.first ?? 0) {
                        flows[i].middle.insert(flows[rnd].middle.first ?? 0, at: 0)
                        flows[rnd].middle.removeFirst()
                    }
                    if isNeighbor(end1: flows[rnd].middle.last ?? 9, end2: flows[i].middle.last ?? 9) {
                        flows[i].middle.append(flows[rnd].middle.last ?? 9)
                        flows[rnd].middle.removeLast()
                    }
                }
            }
        }
        randomizecolors()
        drawDots()
    }
    private var dot: Dot = Dot(color: .clear, dot: 0)
    private var j: Int = 0
    func move(i: Int) {
        if dots.first(where: { $0.dot == i }) != nil {
            dot = dots.first(where: { $0.dot == i }) ?? Dot(color: .clear, dot: 0)
        }
                
        if endDrag == true { j += 1 }
        endDrag = false
        
        for j in 0..<lines.count {
            if lines[j].color == dot.color {
                lines[j].segment.append(i)
            }
        }
    }
    
    func isNeighbor(end1: Int, end2: Int) -> Bool {
        return ( abs(end1 - end2) == 1 || abs(end1 - end2) == 10 ) &&
        !(end1 == 0  && end2 == 19) && !(end2 ==  0 && end1 == 19) &&
        !(end1 == 10 && end2 ==  9) && !(end2 == 10 && end1 ==  9) &&
        !(end1 == 20 && end2 == 19) && !(end2 == 20 && end1 == 19) &&
        !(end1 == 30 && end2 == 29) && !(end2 == 30 && end1 == 29) &&
        !(end1 == 40 && end2 == 39) && !(end2 == 40 && end1 == 39) &&
        !(end1 == 50 && end2 == 49) && !(end2 == 50 && end1 == 49) &&
        !(end1 == 60 && end2 == 59) && !(end2 == 60 && end1 == 59) &&
        !(end1 == 70 && end2 == 69) && !(end2 == 70 && end1 == 69) &&
        !(end1 == 80 && end2 == 79) && !(end2 == 80 && end1 == 79) &&
        !(end1 == 90 && end2 == 89) && !(end2 == 90 && end1 == 89)
    }
}


