//
//  LaunchView5.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView5: View {
    var body: some View {
        ZStack{
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
                }
           
        }
    }
}

struct LaunchView5_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView5()
    }
}
