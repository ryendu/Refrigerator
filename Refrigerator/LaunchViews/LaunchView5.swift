//
//  LaunchView5.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView5: View {
    @State var showNextView = false
    var body: some View {
        ZStack{
            Color.white
        VStack {
            Spacer()
            Text("\(UserDefaults.standard.string(forKey: "name") ?? "Guess What"), You are Ready to Go! Start saving food from going to the trash! Take a minute to create a fridge and take note of what is in your fridge.")
                .font(.largeTitle)
                .bold()
                .padding()
            Spacer()
            
            
            Button(action: {
                
                self.showNextView.toggle()
            }, label: {
                Image("Next button")
                .renderingMode(.original)
                .padding(.bottom, 50)
            })
            
            
        }
           if self.showNextView{
                TabBarView()
            }
            
        }
    }
}

struct LaunchView5_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView5()
    }
}
