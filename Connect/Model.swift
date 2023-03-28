//
//  Model.swift
//  ConnecttheDots
//
//  Created by Alex Resnik on 2/27/23.
//

import Foundation
import SwiftUI

final class Model: ObservableObject {
    
    @Published var lines: [Line] = []
    @Published var dots: [Dot] = []
    private var color: [Color] = [
        .red, .blue, .green, .orange, .yellow, .gray, .purple, .brown, .cyan, .indigo ].shuffled()
    
    struct Flow {
        var color: Color
        var middles: [Int]
    }
    
    struct Dot: Equatable {
        var color: Color
        var x: Int
        var y: Int
    }
    
    struct Line: Equatable {
        var color: Color
        var start: Dot
        var end: Dot
    }
    
    // Initial flows
    @Published var flows: [Flow] = [
        Flow(color: .red,    middles: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99]),
        Flow(color: .blue,   middles: [1, 11, 21, 31, 41, 51, 61, 71, 81]),
        Flow(color: .green,  middles: [2, 12, 22, 32, 42, 52, 62, 72, 82]),
        Flow(color: .orange, middles: [3, 13, 23, 33, 43, 53, 63, 73, 83]),
        Flow(color: .yellow, middles: [4, 14, 24, 34, 44, 54, 64, 74, 84]),
        Flow(color: .gray  , middles: [5, 15, 25, 35, 45, 55, 65, 75, 85]),
        Flow(color: .purple, middles: [6, 16, 26, 36, 46, 56, 66, 76, 86]),
        Flow(color: .brown,  middles: [7, 17, 27, 37, 47, 57, 67, 77, 87]),
        Flow(color: .cyan,   middles: [8, 18, 28, 38, 48, 58, 68, 78, 88]),
        Flow(color: .indigo, middles: [9, 19, 29, 39, 49, 59, 69, 79, 89]) ]
    
    func randomizecolors() {
        for i in 0..<flows.count {
            flows[i].color = color[i]
        }
    }
    
    func drawDots() {
        for i in 0..<flows.count {
            dots.append(Dot(color: color[i], x: (flows[i].middles.first ?? 0) % 10,
                                             y: (flows[i].middles.first ?? 0) / 10))
            dots.append(Dot(color: color[i], x: (flows[i].middles.last ?? 0) % 10,
                                             y: (flows[i].middles.last ?? 0) / 10))
        }
    }
    
    func randomize() {
        for _ in 0..<100 {
        let rnd: Int = Int.random(in: 0..<flows.count)
            for i in 0..<flows.count {
                if flows[rnd].middles.count > 3 {
                    if isNeighbor(end1: flows[rnd].middles.first ?? 0, end2: flows[i].middles.first ?? 0) {
                        flows[i].middles.insert(flows[rnd].middles.first ?? 0, at: 0)
                        flows[rnd].middles.removeFirst()
                    }
                    if isNeighbor(end1: flows[rnd].middles.last ?? 9, end2: flows[i].middles.last ?? 9) {
                        flows[i].middles.append(flows[rnd].middles.last ?? 9)
                        flows[rnd].middles.removeLast()
                    }
                }
            }
        }
        randomizecolors()
        drawDots()
    }
    
    func move(i: Int) {

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


