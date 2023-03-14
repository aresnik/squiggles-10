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
    @Published var middle: [Color] = Array(repeating: .clear, count: 100)
    private var flowColor: Color = .clear
    
    func start() {
        end[0] = .red;     end[9] = .red
        end[10] = .blue;   end[19] = .blue
        end[20] = .green;  end[29] = .green
        end[30] = .orange; end[39] = .orange
        end[40] = .yellow; end[49] = .yellow
        end[50] = .gray;   end[59] = .gray
        end[60] = .purple; end[69] = .purple
        end[70] = .brown;  end[79] = .brown
        end[80] = .cyan;   end[89] = .cyan
        end[90] = .indigo; end[99] = .indigo
    }
    
    func randomize() {

    }
    
    func move(i: Int) {
        if end[i] != .clear { flowColor = end[i] }
        middle[i] = flowColor
    }
}


