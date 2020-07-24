//
//  LaunchView2.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView3: View {
    @State var showNextView = false
    
    var body: some View {
        ZStack{
            VStack {
                
                Spacer()
                    Image(systemName: "house.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                        .padding()
                Text("Get Greeted with a daily streak & goal and add food items with a few taps from the Home page.")
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
