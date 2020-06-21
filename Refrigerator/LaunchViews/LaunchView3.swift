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
            Color.white
            VStack {
                Spacer()
                Image("home view mock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("In Your home page, you get a new random fun fact each time you open the app, a reminder of foods that will go bad soon, and a shopping list.")
                    .padding()
                    .layoutPriority(1)
                
                Button(action: {
                    
                    self.showNextView.toggle()
                }, label: {Image("Next button")
                    .renderingMode(.original)}).padding(.bottom, CGFloat(60))
                
                Spacer()
            }
            if self.showNextView{
                LaunchView4()
            }
        }
        
        
    }
}

struct LaunchView3_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView3()
    }
}