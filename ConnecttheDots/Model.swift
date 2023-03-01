//
//  Model.swift
//  ConnecttheDots
//
//  Created by Alex Resnik on 2/27/23.
//

import Foundation
import SwiftUI

final class Model: ObservableObject {

    @Published var end: [Color] = Array(repeating: .clear, count: 100)
    @Published var horizontal: [Color] = Array(repeating: .clear, count: 90)
    @Published var verticle: [Color] = Array(repeating: .clear, count: 90)
    @Published var corner: [Color] = Array(repeating: .clear, count: 100)
    
    func start() {
        end[0] = .red; end[90] = .red
        for i in stride(from: 0, to: 90, by: 10) {
            verticle[i] = .red
        }
        end[1] = .blue; end[91] = .blue
        for i in stride(from: 1, through: 81, by: 10) {
            verticle[i] = .blue
        }
        end[2] = .green; end[92] = .green
        for i in stride(from: 2, through: 82, by: 10) {
            verticle[i] = .green
        }
        end[3] = .orange; end[93] = .orange
        for i in stride(from: 3, through: 83, by: 10) {
            verticle[i] = .orange
        }
        end[4] = .yellow; end[94] = .yellow
        for i in stride(from: 4, through: 84, by: 10) {
            verticle[i] = .yellow
        }
        end[5] = .gray; end[95] = .gray
        for i in stride(from: 5, through: 85, by: 10) {
            verticle[i] = .gray
        }
        end[6] = .purple; end[96] = .purple
        for i in stride(from: 6, through: 86, by: 10) {
            verticle[i] = .purple
        }
        end[7] = .brown; end[97] = .brown
        for i in stride(from: 7, through: 87, by: 10) {
            verticle[i] = .brown
        }
        end[8] = .cyan; end[98] = .cyan
        for i in stride(from: 8, through: 88, by: 10) {
            verticle[i] = .cyan
        }
        end[9] = .indigo; end[99] = .indigo
        for i in stride(from: 9, through: 89, by: 10) {
            verticle[i] = .indigo
        }
    }
}
