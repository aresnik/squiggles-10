//
//  Model9.swift
//  Squiggles
//
//  Created by Alex Resnik on 2/27/23.
//

import SwiftUI
import AVFAudio

final class Model9: ObservableObject {

    // Initial squiggles
    @Published var squiggles: [Squiggle] = [
        Squiggle(color: .red,    middle: [0,  9, 18, 27, 36, 45, 54, 63,
                                     72, 73, 74, 75, 76, 77, 78, 79, 80]),
        Squiggle(color: .blue,   middle: [1, 10, 19, 28, 37, 46, 55, 64]),
        Squiggle(color: .green,  middle: [2, 11, 20, 29, 38, 47, 56, 65]),
        Squiggle(color: .orange, middle: [3, 12, 21, 30, 39, 48, 57, 66]),
        Squiggle(color: .yellow, middle: [4, 13, 22, 31, 40, 49, 58, 67]),
        Squiggle(color: .gray  , middle: [5, 14, 23, 32, 41, 50, 59, 68]),
        Squiggle(color: .purple, middle: [6, 15, 24, 33, 42, 51, 60, 69]),
        Squiggle(color: .brown,  middle: [7, 16, 25, 34, 43, 52, 61, 70]),
        Squiggle(color: .cyan,   middle: [8, 17, 26, 35, 44, 53, 62, 71]) ]
    @Published var lines: [Line] = [
        Line(color: .red,    segment: []),
        Line(color: .blue,   segment: []),
        Line(color: .green,  segment: []),
        Line(color: .orange, segment: []),
        Line(color: .yellow, segment: []),
        Line(color: .gray  , segment: []),
        Line(color: .purple, segment: []),
        Line(color: .brown,  segment: []),
        Line(color: .cyan,   segment: []) ]
    @Published var dots: [Dot] = []
    @Published var k: Int = 0
    @Published var moves: Int = 0
    @Published var perfectGames: Int = 0
    @Published var perfectStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var solved: Bool = false
    @Published var message: String = "SOLVED!"
    
    private var color: [Color] = [
        .red, .blue, .green, .orange, .yellow, .gray, .purple, .brown, .cyan ].shuffled()
    private var soundPlayer: AVAudioPlayer = AVAudioPlayer()
    private var isConnected: Bool = false
    private var defaults: UserDefaults = UserDefaults.standard
    
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
    
    func save() {
        perfectGames = defaults.integer(forKey: "perfectGames9")
        perfectStreak = defaults.integer(forKey: "perfectStreak9")
        longestStreak = defaults.integer(forKey: "longestStreak9")
        if message == "PERFECT!" {
            perfectGames += 1
            perfectStreak += 1
        } else {
            perfectStreak = 0
        }
        if perfectStreak > longestStreak {
            defaults.set(perfectStreak, forKey: "longestStreak9")
        }
        defaults.set(moves, forKey: "moves9")
        defaults.set(perfectGames, forKey: "perfectGames9")
        defaults.set(perfectStreak, forKey: "perfectStreak9")
        defaults.set(message, forKey: "message9")
    }
    
    func load() {
        moves = defaults.integer(forKey: "moves9")
        perfectGames = defaults.integer(forKey: "perfectGames9")
        perfectStreak = defaults.integer(forKey: "perfectStreak9")
        longestStreak = defaults.integer(forKey: "longestStreak9")
        message = defaults.string(forKey: "message9") ?? ""

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
        moves = 0
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
    
    func countMoves() {
        if !isConnected {
            if isPairConnected() {
                isConnected = true
                moves += 1
                if moves == 9 {
                    message = "PERFECT!"
                } else {
                    message = "SOLVED!"
                }
                playSoundMove()
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.impactOccurred()
            }
        } else if !isPairConnected() {
            isConnected = false
        }
    }
    
    func playSoundMove() {
        do {
            let url =  Bundle.main.url(forResource: "move", withExtension: "mp3")
            soundPlayer = try AVAudioPlayer(contentsOf: url!)
            soundPlayer.volume = 0.2
            soundPlayer.prepareToPlay()
            soundPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSoundTada() {
        do {
            let url =  Bundle.main.url(forResource: "tada", withExtension: "mp3")
            soundPlayer = try AVAudioPlayer(contentsOf: url!)
            soundPlayer.volume = 0.01
            soundPlayer.prepareToPlay()
            soundPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
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
        return ( abs(end1 - end2) == 1 || abs(end1 - end2) == 9 ) &&
        !(end1 == 0  && end2 == 17) && !(end2 ==  0 && end1 == 17) &&
        !(end1 == 9  && end2 ==  8) && !(end2 ==  9 && end1 ==  8) &&
        !(end1 == 18 && end2 == 17) && !(end2 == 18 && end1 == 19) &&
        !(end1 == 27 && end2 == 26) && !(end2 == 27 && end1 == 26) &&
        !(end1 == 36 && end2 == 35) && !(end2 == 36 && end1 == 35) &&
        !(end1 == 45 && end2 == 44) && !(end2 == 45 && end1 == 44) &&
        !(end1 == 54 && end2 == 53) && !(end2 == 54 && end1 == 53) &&
        !(end1 == 63 && end2 == 62) && !(end2 == 63 && end1 == 62) &&
        !(end1 == 72 && end2 == 71) && !(end2 == 72 && end1 == 71)
    }
    
    func isSolved() {
        var count: Int = 0
        for line in lines {
            for integer in line.segment {
                if integer >= 0 && integer <= 81 {
                    count += 1
                }
            }
        }
        if count == 81 {
            solved = true
            save()
        }
    }
}


