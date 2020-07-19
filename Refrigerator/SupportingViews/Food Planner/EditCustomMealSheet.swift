//
//  EditCustomMealSheet.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/18/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct EditCustomMealSheet: View {
    @State var item: MealItem
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var title = ""
    @State var icon = ""
    var body: some View {
        
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel").foregroundColor(.orange)
                    }).padding()
            }
            Text("Edit This Meal")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Group{
                HStack{
                    
                    TextField("emoji", text: self.$icon, onEditingChanged: {_ in
                        self.item.name = self.title
                        self.item.icon = self.icon
                        try? self.managedObjectContext.save()
                    }, onCommit: {
                        self.item.name = self.title
                        self.item.icon = self.icon
                        try? self.managedObjectContext.save()
                    })
                            .font(.custom("SFProDisplay", size: 16))
                            .padding(.leading, 8)
                    TextField("meal name", text: self.$title, onEditingChanged: {_ in
                        self.item.name = self.title
                        self.item.icon = self.icon
                        try? self.managedObjectContext.save()
                    }, onCommit: {
                        self.item.name = self.title
                        self.item.icon = self.icon
                        try? self.managedObjectContext.save()
                    })
                            .font(.custom("SFProDisplay", size: 16))
                            .multilineTextAlignment(.leading)
                                
                    Spacer()
                            
                    
                    
                }
                .padding()
                .background(Rectangle().cornerRadius(12)
                .foregroundColor(Color("whiteAndGray"))
                .shadow(color: Color("shadows"), radius: 3)
                )
                .padding(.horizontal)
            }.padding()
            Spacer()
            Button(action: {
                self.item.name = self.title
                self.item.icon = self.icon
                try? self.managedObjectContext.save()
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("Update")
                }).padding()
        }.onAppear{
            self.title = self.item.name ?? ""
            self.icon = self.item.icon ?? ""
        }
        .onDisappear{
            self.item.name = self.title
            self.item.icon = self.icon
            try? self.managedObjectContext.save()
        }
    }
}

