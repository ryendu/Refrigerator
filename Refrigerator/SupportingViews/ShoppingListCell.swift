//
//  ShoppingListCell.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/1/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct ShoppingListCell: View {
    var icon: String
    var title: String
    @State var checked = false
    var body: some View {
        
        HStack {
            Button(action: {
                //Delete the current cell here using Core Data and have a undo feature
            }, label: {
                
                Circle()
                    .foregroundColor(Color(hex: "F5F6F8"))
                    .overlay(Capsule().stroke(Color(hex: "999999")))
                    .frame(width: 28, height: 28)
                    .padding(.leading)
                
            })
            
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
                    
                }
                Spacer()
                }
            .padding()
            .background(Image("Rectangle").resizable().padding(.horizontal))
            .padding(.bottom)
        }
    
        
    }
}
struct ShoppingListCell_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListCell(icon: "🥦", title: "brocolie")
    }
}
