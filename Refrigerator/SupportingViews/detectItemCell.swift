//
//  DetectItemCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/21/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct DetectItemCell: View {
    @State var icon: String
    @State var title: String
    @State var lastsFor: Int
    
    var body: some View {
        HStack {
            TextField(icon, text: $icon)
                .frame(width: 40, height: 40)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
            TextField(title, text: $title)
                        .font(.custom("SF Pro Text", size: 16))
                        .multilineTextAlignment(.leading)
                
            
               
            
            Stepper(value: $lastsFor, in: 1...1000) {
                Text("lasts for \((lastsFor)) days")
                .font(.custom("SF Compact Display", size: 16))
                .foregroundColor(Color(hex: "868686"))
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 80)
            }
        
            }
        .padding()
        .background(Image("Rectangle").resizable().padding(.horizontal))
        .padding(.bottom)
    
        
    }
}

struct DetectItemCell_Previews: PreviewProvider {
    static var previews: some View {
        DetectItemCell(icon: "🥕", title: "nice", lastsFor: 200)
    }
}
