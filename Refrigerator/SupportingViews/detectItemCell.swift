//
//  DetectItemCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/21/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct DetectItemCell: View {
    @Binding var foodsToDisplay: [refrigeItem]
    var index: Int
    @State var icon: String
    @State var title: String
    @State var lastsFor: Int
    
    
    var body: some View {
        HStack{
            TextField(icon, text: $icon)
            .frame(width: 40, height: 40)
            .multilineTextAlignment(.center)
            .font(.custom("SF Pro Text", size: 50))
        VStack{
            HStack{
                
                TextField(title, text: $title)
                            .font(.custom("SF Pro Text", size: 20))
                            .multilineTextAlignment(.leading)
            }
        HStack {
            
                
            
               
            
            Stepper(value: $lastsFor, in: 1...1000) {
                Text("lasts for \((lastsFor)) days")
                .font(.custom("SF Compact Display", size: 16))
                .foregroundColor(Color(hex: "868686"))
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 80)
            }
            Button(action: {
                self.foodsToDisplay.remove(at: self.index)
            }, label: {
                Image(systemName: "minus.circle")
                    .renderingMode(.original)
                    .padding()
            })
        
            }
        
    
        
            }
            
        }.padding()
    .background(Rectangle().cornerRadius(16).padding(.horizontal)
    .foregroundColor(Color("cellColor"))
    )
    .padding(.bottom)
}
}
struct DetectItemCoreDataCell: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var foodsToDisplay: FoodItem
    @State var icon = ""
    @State var title = ""
    @State var lastsFor = 7
    var body: some View {
        HStack{
            TextField(icon, text: $icon)
            .frame(width: 40, height: 40)
            .multilineTextAlignment(.center)
            .font(.custom("SF Pro Text", size: 50))
        VStack{
            HStack{
                
                TextField(title, text: $title)
                            .font(.custom("SF Pro Text", size: 20))
                            .multilineTextAlignment(.leading)
            }
        HStack {
            
                
            
               
            
            Stepper(value: $lastsFor, in: 1...1000) {
                Text("lasts for \((lastsFor)) days")
                .font(.custom("SF Compact Display", size: 16))
                .foregroundColor(Color(hex: "868686"))
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 80)
            }
            Button(action: {
                self.foodsToDisplay.removeFromFoodItem(self.foodsToDisplay)
                try?self.managedObjectContext.save()
                
            }, label: {
                Image(systemName: "minus.circle")
                    .renderingMode(.original)
                    .padding()
            })
        
            }
        
    
        
            }.onAppear(perform: {
                self.icon = self.foodsToDisplay.wrappedSymbol
                self.title = self.foodsToDisplay.wrappedName
                self.lastsFor = Int(self.foodsToDisplay.wrappedStaysFreshFor)
            })
        .onDisappear(perform: {
                self.foodsToDisplay.name = self.title
                self.foodsToDisplay.symbol = self.icon
                self.foodsToDisplay.staysFreshFor = Int16(self.lastsFor)
                try?self.managedObjectContext.save()
            })
            
        }.padding()
    .background(Rectangle().cornerRadius(16).padding(.horizontal)
    .foregroundColor(Color("cellColor"))
    )
    .padding(.bottom)
}
}
//TODO: When I get back, start esembling the progress view
        
