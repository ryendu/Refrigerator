//
//  LaunchView2.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView3: View {
    @Binding var showNextView: Bool
    var body: some View {
        return ZStack{
            Color(hex: "B9FFAC").edgesIgnoringSafeArea(.all)
            VStack {
                
                Spacer()
                    Image(systemName: "house.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                        .padding()
                Text("Get Greeted with a daily streak & goal. Add new food items with just a few taps from the Home page.")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, CGFloat())
                .padding(.horizontal, CGFloat(20))
                
               
            Spacer()
            
            NavigationLink(destination: LaunchView4(showNextView: self.$showNextView), label: {
                Image("Next button").renderingMode(.original).padding()
            })
        }
        }
        
        
}
}
