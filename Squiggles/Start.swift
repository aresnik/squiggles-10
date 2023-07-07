//
//  Start.swift
//  Squiggles
//
//  Start.swift
//  Squiggles
//
//  Created by Alex Resnik on 4/25/23.
//

import SwiftUI

struct Start: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            Select()
        } else {
            Color.black
                .ignoresSafeArea()
                .overlay(
                VStack {
                    VStack {
                        Image("splashScreen")
                            .resizable()
                            .frame(width: 300, height: 300)
                        Text("Squiggles")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            size = 0.9
                            opacity = 1.00
                        }
                    }
                }
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        Start()
    }
}
