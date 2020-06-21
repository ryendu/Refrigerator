//
//  LaunchView4.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView2: View {
    @State private var name = UserDefaults.standard.string(forKey: "name") ?? ""
    @State private var didFinishTyping = false
    @State var showNextView = false
    var body: some View {
        ZStack{
            Color.white
            .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("👋")
                    .font(.custom("Open Sans", size: CGFloat(60)))
                Text("Hey there, whats your name?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                TextField("name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                Spacer()
                
                Button(action: {
                    UserDefaults.standard.set(self.name, forKey: "name")
                    self.showNextView.toggle()
                }, label: {Image("Next button")
                    .renderingMode(.original)}).padding(.bottom, CGFloat(60))
                Spacer()
                
            }
            if self.showNextView{
                LaunchView3()
            }
        }
    }
}
struct LaunchView2_Previews: PreviewProvider {
    
    static var previews: some View {
        LaunchView2()
    }
}