//
//  SeeMoreView.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/1/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct SeeMoreView: View {
    
    //TODO: only displays food that will go bad in the next 4 days
    @State var refrigeItemsPreview = [refrigeItem(icon: "🥚", title: "eggs", daysLeft: 8),refrigeItem(icon: "🥑", title: "avocados", daysLeft: 5),refrigeItem(icon: "🍍", title: "pineapple", daysLeft: 1),refrigeItem(icon: "🍌", title: "Bananas", daysLeft: 1),refrigeItem(icon: "🍉", title: "watermellons", daysLeft: 4)]
    var body: some View {
        VStack {
            Text("Eat These Foods Soon")
                .font(.largeTitle)
                .padding()
            
            ForEach(self.refrigeItemsPreview, id: \.self) { item in
                RefrigeratorItemCell(icon: item.icon, title: item.title, lastsFor: item.daysLeft)
                
            }
            Spacer()
        }
    }
}

struct SeeMoreView_Previews: PreviewProvider {
    static var previews: some View {
        SeeMoreView()
    }
}
