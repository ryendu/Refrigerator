//
//  LaunchView3.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView4: View {
    var body: some View {
                VStack {
            Spacer()
            Image("refrigerator view mock")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Text("In Your fridge page, You can see all of the places where you store food.")
                .padding()
                .layoutPriority(1)
                
            Spacer()
            NavigationLink(destination: LaunchView5(), label: {
                Image("Next button")
                    .renderingMode(.original)
                
                
            })
                .padding(.bottom)
        
        }
    }
}

struct LaunchView4_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView4()
    }
}
