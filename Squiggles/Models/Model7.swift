//
//  Model7.swift
//  Squiggles
//
//  Created by Alex Resnik on 2/27/23.
//

import SwiftUI
import AVFAudio

final class Model7: ObservableObject {

    // Initial squiggles
    @Published var squiggles: [Squiggle] = [
        Squiggle(color: .red,    middle: [0,  7, 14, 21, 28, 35,
                                     42, 43, 44, 45, 46, 47, 48]),
        Squiggle(color: .blue,   middle: [1,  8, 15, 22, 29, 36]),
        Squiggle(color: .green,  middle: [2,  9, 16, 23, 30, 37]),
        Squiggle(color: .orange, middle: [3, 10, 17, 24, 31, 38]),
        Squiggle(color: .yellow, middle: [4, 11, 18, 25, 32, 39]),
        Squiggle(color: .gray  , middle: [5, 12, 19, 26, 33, 40]),
        Squiggle(color: .purple, middle: [6, 13, 20, 27, 34, 41]) ]
    @Published var lines: [Line] = [
        Line(color: .red,    segment: []),
        Line(color: .blue,   segment: []),
        Line(color: .green,  segment: []),
        Line(color: .orange, segment: []),
        Line(color: .yellow, segment: []),
        Line(color: .gray  , segment: []),
        Line(color: .purple, segment: []) ]
    @Published var dots: [Dot] = []
    @Published var k: Int = 0
    @Published var timeCurrent: String = ""
    @Published var timeBest: String = ""
    @Published var time: String = "00:00"
    @Published var moves: Int = 0
    @Published var perfectGames: Int = 0
    @Published var perfectStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var solved: Bool = false
    @Published var message: String = "SOLVED!"
    
    private var color: [Color] = [
        .red, .blue, .green, .orange, .yellow, .gray, .purple ].shuffled()
    private var soundPlayer: AVAudioPlayer = AVAudioPlayer()
    private var isConnected: Bool = false
    private var lastDotColor: Color = .clear
    private var timer: Timer = Timer()
    private var elapsed: Int = 0
    private var elapsedBest: Int = 0
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
        perfectGames = defaults.integer(forKey: "perfectGames7")
        perfectStreak = defaults.integer(forKey: "perfectStreak7")
        longestStreak = defaults.integer(forKey: "longestStreak7")
        if message == "PERFECT!" {
            perfectGames += 1
            perfectStreak += 1
        } else {
            perfectStreak = 0
        }
        if perfectStreak > longestStreak {
            defaults.set(perfectStreak, forKey: "longestStreak7")
        }
        elapsedBest = defaults.integer(forKey: "elapsedBest7")
        if elapsedBest == 0 {
            elapsedBest = elapsed
        }
        if elapsed <= elapsedBest {
            defaults.set(elapsed, forKey: "elapsedBest7")
        }
        defaults.set(moves, forKey: "moves7")
        defaults.set(perfectGames, forKey: "perfectGames7")
        defaults.set(perfectStreak, forKey: "perfectStreak7")
        defaults.set(message, forKey: "message7")
        defaults.set(time, forKey: "timeCurrent7")
    }
    
    func load() {
        moves = defaults.integer(forKey: "moves7")
        perfectGames = defaults.integer(forKey: "perfectGames7")
        perfectStreak = defaults.integer(forKey: "perfectStreak7")
        longestStreak = defaults.integer(forKey: "longestStreak7")
        message = defaults.string(forKey: "message7") ?? ""
        timeCurrent = defaults.string(forKey: "timeCurrent7") ?? ""
        elapsedBest = defaults.integer(forKey: "elapsedBest7")
        timeBest = createTimeString(seconds: elapsedBest)
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
        elapsedTime()
    }
    
    func start(i: Int) {
        let dot = dots.first { $0.dot == i }
        for j in 0..<lines.count {
            if lines[j].color == dot?.color {
                k = j
            }
        }
    }
    
    func elapsedTime() {
        elapsed = 0
        time = "00:00"
        timer.invalidate()
        if !timer.isValid {
            timer.fire()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
                elapsed += 1
                time = createTimeString(seconds: elapsed)
            }
        } else {
            timer.invalidate()
        }
    }
    
    func createTimeString(seconds: Int) -> String {
        let m: Int = (seconds/60) % 60
        let s: Int = seconds % 60
        let a = String(format: "%02u:%02u", m, s)
        return a
    }
    
    func move(i: Int) {
        let dot = dots.first { $0.dot == i }
        if isWalkingBack(i: i) && !isConnected  {
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
//            deleteIntersectedLine(i: i)
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
    
    func countMoves(i: Int) {
        if !isConnected {
            if isPairConnected() {
                isConnected = true
                let dot = dots.first { $0.dot == i }
                if dot?.color != lastDotColor {
                    moves += 1
                    lastDotColor = dot?.color ?? .clear
                }
                if moves == 7 {
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
            soundPlayer.volume = 1.0
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
            soundPlayer.volume = 1.0
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
        return ( abs(end1 - end2) == 1 || abs(end1 - end2) == 7 ) &&
        !(end1 == 0  && end2 == 13) && !(end2 ==  0 && end1 == 13) &&
        !(end1 == 7  && end2 ==  6) && !(end2 ==  7 && end1 ==  6) &&
        !(end1 == 14 && end2 == 13) && !(end2 == 14 && end1 == 13) &&
        !(end1 == 21 && end2 == 20) && !(end2 == 21 && end1 == 20) &&
        !(end1 == 28 && end2 == 27) && !(end2 == 28 && end1 == 27) &&
        !(end1 == 35 && end2 == 34) && !(end2 == 35 && end1 == 34) &&
        !(end1 == 42 && end2 == 41) && !(end2 == 42 && end1 == 41)
    }
    
    func isSolved() {
        var count: Int = 0
        for line in lines {
            for integer in line.segment {
                if integer >= 0 && integer <= 49 {
                    count += 1
                }
            }
        }
        if count == 49 {
            solved = true
            save()
            timer.invalidate()
        }
    }
}


