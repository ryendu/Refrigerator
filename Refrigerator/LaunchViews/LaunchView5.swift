//
//  LaunchView5.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView5: View {
    @Binding var showNextView: Bool
    var body: some View {
        return ZStack{
            Color(hex: "B9FFAC").edgesIgnoringSafeArea(.all)
            VStack {
                        
                        Spacer()
                    HStack{
                            Image(systemName: "circle.grid.hex")
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                                .padding()
                        
                    }
                        Text("Only keep track of what you have and don't worry about how much you have.")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, CGFloat())
                        .padding(.horizontal, CGFloat(20))
                    Spacer()
            Button(action: {
                self.showNextView = true
            }, label: {
                Image("Next button").renderingMode(.original).padding()
            })
            }
    }
    }
}
