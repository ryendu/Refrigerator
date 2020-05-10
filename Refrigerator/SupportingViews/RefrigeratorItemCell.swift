//
//  RefrigeratorItemCell.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/1/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct RefrigeratorItemCell: View {
    var icon: String
    var title: String
    var lastsFor: Int
    var body: some View {
        HStack {
            Text(icon)
                .font(.largeTitle)
                .padding(.leading, 8)
            VStack {
                HStack {
                    Text(title)
                        .font(.custom("SF Pro Text", size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                HStack {
                    Text("lasts for \(lastsFor) days")
                        .font(.custom("SF Compact Display", size: 16))
                        .foregroundColor(Color(hex: "868686"))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            Spacer()
            }
        .padding()
        .background(Image("Rectangle").resizable().padding(.horizontal))
        .padding(.bottom)
    
        
    }
}

struct RefrigeratorItemCell_Previews: PreviewProvider {
    static var previews: some View {
        RefrigeratorItemCell(icon: "🥨", title: "Creme Brule", lastsFor: 3)
    }
}


