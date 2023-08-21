//
//  Alert8.swift
//  Squiggles
//
//  Created by Alex Resnik on 4/25/23.
//

import SwiftUI

struct Alert8: View {
    
    @StateObject private var viewModel = Model8()
    @State var isActive: Bool = false
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        if isActive {
           End8()
        } else {
            VStack {
                if idiom == .phone { alertIphone }
                if idiom == .pad { alertIpad }
            }
        }
    }
}

extension Alert8 {
    private var alertIphone: some View {
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

extension Alert8 {
    private var alertIpad: some View {
        VStack {
            Text(viewModel.message)
                .font(.system(size: 50))
                .foregroundColor(.white)
                .padding(35)
            Button("OK") {
                isActive = true
                viewModel.solved = false
            }
            .font(.system(size: 40))
            .foregroundColor(.white)
            .padding(25)
            .overlay(
                RoundedRectangle(cornerRadius: 45)
                    .stroke(.white, lineWidth: 4)
            )
        }
        .padding()
        .frame(width: 500, height: 500)
        .background(.black)
        .cornerRadius(24)
        .onAppear(perform: viewModel.load)
        .onAppear(perform: viewModel.playSoundTada)
    }
}

struct CustomAlert8_Previews: PreviewProvider {
    static var previews: some View {
        Alert8()
    }
}

