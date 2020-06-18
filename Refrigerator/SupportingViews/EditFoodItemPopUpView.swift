//
//  EditFoodItemPopUpView.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/27/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData

struct EditFoodItemPopUpView: View {

    @State var foodItem: FoodItem
    @State var icon: String
    @State var title: String
    @State var lastsFor: Int
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Spacer()
                    HStack{
                        TextField(icon, text: $icon)
                    .frame(width: 40, height: 40)
                    .multilineTextAlignment(.center)
                        .font(.largeTitle)
                TextField(title, text: $title)
                    .font(.title)
                        
                    }.padding(.bottom)
                
                    
                        
                    
                       
                    
                    Stepper(value: $lastsFor, in: 1...1000) {
                        Text("lasts for \((lastsFor)) days")
                        .font(.custom("SF Compact Display", size: 16))
                        .foregroundColor(Color(hex: "868686"))
                            .multilineTextAlignment(.leading)
                            .frame(minWidth: 80)
                    }
            Spacer()
            Button(action: {
                self.foodItem.name = self.title
                self.foodItem.symbol = self.icon
                self.foodItem.staysFreshFor = Int16(self.lastsFor)
                try? self.managedObjectContext.save()
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("Update")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 200.0, height: 45.5)
                    
                
            })
            
            }.padding(20)
            .frame(width: 350, height: 450)
        
        
    }
}


