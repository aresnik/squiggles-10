//
//  Model6.swift
//  Squiggles
//
//  Created by Alex Resnik on 2/27/23.
//

import SwiftUI
import AVFAudio

final class Model6: ObservableObject {

    // Initial squiggles
    @Published var squiggles: [Squiggle] = [
        Squiggle(color: .red,    middle: [0,  6, 12, 18, 24,
                                     30, 31, 32, 33, 34, 35]),
        Squiggle(color: .blue,   middle: [1,  7, 13, 19, 25]),
        Squiggle(color: .green,  middle: [2,  8, 14, 20, 26]),
        Squiggle(color: .orange, middle: [3,  9, 15, 21, 27]),
        Squiggle(color: .yellow, middle: [4, 10, 16, 22, 28]),
        Squiggle(color: .gray  , middle: [5, 11, 17, 23, 29]) ]
    @Published var lines: [Line] = [
        Line(color: .red,    segment: []),
        Line(color: .blue,   segment: []),
        Line(color: .green,  segment: []),
        Line(color: .orange, segment: []),
        Line(color: .yellow, segment: []),
        Line(color: .gray  , segment: []) ]
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
        .red, .blue, .green, .orange, .yellow, .gray ].shuffled()
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
        perfectGames = defaults.integer(forKey: "perfectGames6")
        perfectStreak = defaults.integer(forKey: "perfectStreak6")
        longestStreak = defaults.integer(forKey: "longestStreak6")
        if message == "PERFECT!" {
            perfectGames += 1
            perfectStreak += 1
        } else {
            perfectStreak = 0
        }
        if perfectStreak > longestStreak {
            defaults.set(perfectStreak, forKey: "longestStreak6")
        }
        elapsedBest = defaults.integer(forKey: "elapsedBest6")
        if elapsedBest == 0 {
            elapsedBest = elapsed
        }
        if elapsed <= elapsedBest {
            defaults.set(elapsed, forKey: "elapsedBest6")
        }
        defaults.set(moves, forKey: "moves6")
        defaults.set(perfectGames, forKey: "perfectGames6")
        defaults.set(perfectStreak, forKey: "perfectStreak6")
        defaults.set(message, forKey: "message6")
        defaults.set(time, forKey: "timeCurrent6")
    }
    
    func load() {
        moves = defaults.integer(forKey: "moves6")
        perfectGames = defaults.integer(forKey: "perfectGames6")
        perfectStreak = defaults.integer(forKey: "perfectStreak6")
        longestStreak = defaults.integer(forKey: "longestStreak6")
        message = defaults.string(forKey: "message6") ?? ""
        timeCurrent = defaults.string(forKey: "timeCurrent6") ?? ""
        elapsedBest = defaults.integer(forKey: "elapsedBest6")
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
        if isWalkingBack(i: i) && !isConnected {
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
                if moves <= 6 {
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
        return ( abs(end1 - end2) == 1 || abs(end1 - end2) == 6 ) &&
        !(end1 == 0  && end2 == 11) && !(end2 ==  0 && end1 == 11) &&
        !(end1 == 6  && end2 ==  5) && !(end2 ==  6 && end1 ==  5) &&
        !(end1 == 12 && end2 == 11) && !(end2 == 12 && end1 == 11) &&
        !(end1 == 18 && end2 == 17) && !(end2 == 18 && end1 == 17) &&
        !(end1 == 24 && end2 == 23) && !(end2 == 24 && end1 == 23) &&
        !(end1 == 30 && end2 == 29) && !(end2 == 30 && end1 == 29)
    }
    
    func isSolved() {
        var count: Int = 0
        for line in lines {
            for integer in line.segment {
                if integer >= 0 && integer <= 36 {
                    count += 1
                }
            }
        }
        if count == 36 {
            solved = true
            save()
            timer.invalidate()
        }
    }
}


