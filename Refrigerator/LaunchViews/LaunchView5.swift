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
        VStack {
            Spacer()
            Text("\(UserDefaults.standard.string(forKey: "name") ?? "name not set"), You are Ready to Go! Start saving food from going to the trash!")
                .font(.largeTitle)
                .bold()
                .padding()
            Spacer()
            NavigationLink(destination: TabBarView(), label: {
                Image("Next button")
                .renderingMode(.original)
                .padding(.bottom, 50)
                })
            
            
        }
        
    }
}

struct LaunchView5_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView5()
    }
}
