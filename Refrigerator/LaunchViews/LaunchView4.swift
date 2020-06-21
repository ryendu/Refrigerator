//
//  LaunchView3.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView4: View {
    @State var showNextView = false

    var body: some View {
        ZStack{
            Color.white
                VStack {
            Spacer()
            Image("refrigerator view mock")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Text("In Your Refrigerator View, You can see all of the places where you store food.")
                .padding()
                .layoutPriority(1)
                
            Spacer()
            Button(action: {
                
                self.showNextView.toggle()
            }, label: {Image("Next button")
                .renderingMode(.original)}).padding(.bottom, CGFloat(60))
        
        }
            if self.showNextView{
                LaunchView5()
            }
        }
    }
}

struct LaunchView4_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView4()
    }
}
