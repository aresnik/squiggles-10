//
//  Select.swift
//  Squiggles
//
//  Created by Alex Resnik on 7/7/23.
//

import SwiftUI

struct Select: View {
    @State var GoToBoard6 = false
    @State var GoToBoard7 = false
    @State var GoToBoard8 = false
    @State var GoToBoard9 = false
    @State var GoToBoard10 = false
    var body: some View {
        if GoToBoard6 {
            Board6()
        } else if GoToBoard7 {
            Board7()
        } else if GoToBoard8 {
            Board8()
        } else if GoToBoard9 {
            Board9()
        } else if GoToBoard10 {
            Board10()
        } else {
            Color.black
                .ignoresSafeArea()
                .overlay(
                    VStack {
                        Text("Select Board")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        Spacer()
                        VStack {
                            Button(action: {
                                GoToBoard6 = true
                            }, label: {
                                Text("6x6 Squares")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        Capsule()
                                            .stroke(Color.white, lineWidth: 2.0)
                                    )
                            }).padding()
                            
                            Button(action: {
                                GoToBoard7 = true
                            }, label: {
                                Text("7x7 Squares")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        Capsule()
                                            .stroke(Color.white, lineWidth: 2.0)
                                    )
                            }).padding()
                            
                            Button(action: {
                                GoToBoard8 = true
                            }, label: {
                                Text("8x8 Squares")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        Capsule()
                                            .stroke(Color.white, lineWidth: 2.0)
                                    )
                            }).padding()
                            
                            Button(action: {
                                GoToBoard9 = true
                            }, label: {
                                Text("9x9 Squares")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        Capsule()
                                            .stroke(Color.white, lineWidth: 2.0)
                                    )
                            }).padding()
                            
                            Button(action: {
                                GoToBoard10 = true
                            }, label: {
                                Text("10x10 Squares")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        Capsule()
                                            .stroke(Color.white, lineWidth: 2.0)
                                    )
                            }).padding()
                        }
                        Spacer()
                        
                    }
                )
        }
    }
}


struct Select_Previews: PreviewProvider {
    static var previews: some View {
        Select()
    }
}
