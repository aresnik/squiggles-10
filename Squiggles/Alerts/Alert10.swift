//
//  Alert10.swift
//  Squiggles
//
//  Created by Alex Resnik on 4/25/23.
//

import SwiftUI

struct Alert10: View {
    
    @StateObject private var viewModel = Model10()
    @State var isActive: Bool = false

    var body: some View {
        if isActive {
           End10()
        } else {
            VStack {
                Text(viewModel.message)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .padding()
                Button("OK") {
                    isActive = true
                    viewModel.solved = false
                }
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(.white, lineWidth: 2)
                )
            }
            .padding()
            .frame(width: 250, height: 250)
            .background(.black)
            .cornerRadius(12)
            .onAppear(perform: viewModel.load)
            .onAppear(perform: viewModel.playSoundTada)
        }
    }
}

struct CustomAlert10_Previews: PreviewProvider {
    static var previews: some View {
        Alert10()
    }
}

