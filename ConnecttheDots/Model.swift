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
        end[1] = .blue; end[91] = .blue
        end[2] = .green; end[92] = .green
        end[3] = .orange; end[93] = .orange
        end[4] = .yellow; end[94] = .yellow
        end[5] = .gray; end[95] = .gray
        end[6] = .purple; end[96] = .purple
        end[7] = .brown; end[97] = .brown
        end[8] = .cyan; end[98] = .cyan
        end[9] = .indigo; end[99] = .indigo
    }
    func move(i: Int) {
        if end[i] == .red { verticle[i] = .red }
        if end[i] == .blue { verticle[i] = .blue }
        if verticle[i] == .red { verticle[i + 10] = .red }
        if verticle[i] == .blue { verticle[i + 10] = .blue }
        if end[i] == .green { verticle[i] = .green }
        if end[i] == .orange { verticle[i] = .orange }
        if verticle[i] == .green { verticle[i + 10] = .green }
        if verticle[i] == .orange { verticle[i + 10] = .orange }
        if end[i] == .yellow { verticle[i] = .yellow }
        if end[i] == .gray { verticle[i] = .gray }
        if verticle[i] == .yellow { verticle[i + 10] = .yellow }
        if verticle[i] == .gray { verticle[i + 10] = .gray }
        if end[i] == .purple { verticle[i] = .purple }
        if end[i] == .brown { verticle[i] = .brown }
        if verticle[i] == .purple { verticle[i + 10] = .purple }
        if verticle[i] == .brown { verticle[i + 10] = .brown }
        if end[i] == .cyan { verticle[i] = .cyan }
        if end[i] == .indigo { verticle[i] = .indigo }
        if verticle[i] == .cyan { verticle[i + 10] = .cyan }
        if verticle[i] == .indigo { verticle[i + 10] = .indigo }
    }
}
