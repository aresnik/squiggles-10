//
//  Model.swift
//  Squiggles
//
//  Created by Alex Resnik on 2/27/23.
//

import Foundation
import SwiftUI

final class Model: ObservableObject {

    // Initial squiggles
    @Published var squiggles: [Squiggle] = [
        Squiggle(color: .red,    middle: [0, 10, 20, 30, 40, 50, 60, 70, 80,
                                     90, 91, 92, 93, 94, 95, 96, 97, 98, 99]),
        Squiggle(color: .blue,   middle: [1, 11, 21, 31, 41, 51, 61, 71, 81]),
        Squiggle(color: .green,  middle: [2, 12, 22, 32, 42, 52, 62, 72, 82]),
        Squiggle(color: .orange, middle: [3, 13, 23, 33, 43, 53, 63, 73, 83]),
        Squiggle(color: .yellow, middle: [4, 14, 24, 34, 44, 54, 64, 74, 84]),
        Squiggle(color: .gray  , middle: [5, 15, 25, 35, 45, 55, 65, 75, 85]),
        Squiggle(color: .purple, middle: [6, 16, 26, 36, 46, 56, 66, 76, 86]),
        Squiggle(color: .brown,  middle: [7, 17, 27, 37, 47, 57, 67, 77, 87]),
        Squiggle(color: .cyan,   middle: [8, 18, 28, 38, 48, 58, 68, 78, 88]),
        Squiggle(color: .indigo, middle: [9, 19, 29, 39, 49, 59, 69, 79, 89]) ]
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
    @Published var k: Int = 0
    private var l: Int = -1
    private var color: [Color] = [
        .red, .blue, .green, .orange, .yellow, .gray, .purple, .brown, .cyan, .indigo ].shuffled()
    
    struct Squiggle {
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
        for i in 0..<squiggles.count {
            squiggles[i].color = color[i]
        }
    }
    
    func drawDots() {
        for i in 0..<squiggles.count {
            dots.append(Dot(color: color[i], dot: squiggles[i].middle.first ?? 0))
            dots.append(Dot(color: color[i], dot: squiggles[i].middle.last ?? 0))
        }
    }
    
    func randomize() {
        for _ in 0..<100 {
        let rnd: Int = Int.random(in: 0..<squiggles.count)
            for i in 0..<squiggles.count {
                if squiggles[rnd].middle.count > 3 {
                    if isNeighbor(end1: squiggles[rnd].middle.first ?? 0, end2: squiggles[i].middle.first ?? 0) {
                        squiggles[i].middle.insert(squiggles[rnd].middle.first ?? 0, at: 0)
                        squiggles[rnd].middle.removeFirst()
                    }
                    if isNeighbor(end1: squiggles[rnd].middle.last ?? 9, end2: squiggles[i].middle.last ?? 9) {
                        squiggles[i].middle.append(squiggles[rnd].middle.last ?? 9)
                        squiggles[rnd].middle.removeLast()
                    }
                }
            }
        }
        randomizecolors()
        drawDots()
    }
    
    func start(i: Int) {
        let dot = dots.first { $0.dot == i }
        for j in 0..<lines.count {
            if lines[j].color == dot?.color {
                k = j
            }
        }
    }
    
    func move(i: Int) {
        let dot = dots.first { $0.dot == i }
        if isWalkingBack(i: i) {
            lines[k].segment.removeLast()
        }
        if isPairConnected() { return }
        if lines[k].segment.last != nil {
            if !isNeighbor(end1: lines[k].segment.last ?? 0, end2: i) {
                return
            }
        }
        if (dot != nil && lines[k].color == dot?.color) || (lines[k].segment.last != nil && dot == nil) {
            lines[k].segment.append(i)
        }
        if hasDuplicateLines(in: lines) {
            lines[k].segment.removeLast()
            deleteIntersectedLine(i: i)
        }
    }
    
    func isWalkingBack(i: Int) -> Bool {
        if lines[k].segment.contains(i) {
            return true
        }
        return false
    }
    
    func deleteLine(i: Int) {
        for j in 0..<lines.count {
            if lines[j].segment.contains(i) {
                lines[j].segment.removeAll()
            }
        }
    }
    
    func deleteIntersectedLine(i: Int) {
        for j in 0..<lines.count {
            if lines[j].segment.contains(i) {
                for i in 0..<squiggles.count {
                    if (lines[j].segment.first == squiggles[i].middle.first &&
                        lines[j].segment.last  == squiggles[i].middle.last) ||
                       (lines[j].segment.first == squiggles[i].middle.last  &&
                        lines[j].segment.last  == squiggles[i].middle.first) {
                        lines[j].segment.removeAll()
                    }
                }
            }
        }
    }
    
    func isPairConnected() -> Bool {
        for i in 0..<squiggles.count {
            if (lines[k].segment.first == squiggles[i].middle.first &&
                lines[k].segment.last  == squiggles[i].middle.last) ||
               (lines[k].segment.first == squiggles[i].middle.last  &&
                lines[k].segment.last  == squiggles[i].middle.first) {
                return true
            }
        }
        return false
    }
    
    func hasDuplicateLines(in lines: [Line]) -> Bool {
           var set = Set<Int>()
           for line in lines {
               for integer in line.segment {
                   if set.contains(integer) {
                     return true
                   } else {
                       set.insert(integer)
                   }
               }
           }
           return false
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


