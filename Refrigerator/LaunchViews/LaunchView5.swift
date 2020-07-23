//
//  LaunchView5.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView5: View {
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    var body: some View {
        VStack {
            Spacer()
            Text("\((self.user[0].name == "" ? "Guess What" : self.user[0].name) ?? "Guess What"), You are Ready to Go! Start saving food from going to the trash! Take a minute to create a fridge and take note of what is in your fridge.")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, CGFloat())
                .padding(.horizontal, CGFloat(20))
            Spacer()
            
            
            
            
            
            
        
          
            
        }
    }
}

struct LaunchView5_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView5()
    }
}
