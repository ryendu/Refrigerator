//
//  ShoppingListCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/1/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData

struct ShoppingListCell: View {
    @FetchRequest(entity: ShoppingList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingList.name, ascending: true)]) var shoppingList: FetchedResults<ShoppingList>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var icon: String
    var title: String
    var shoppingItem: ShoppingList
    var body: some View {
        
        HStack {
            Button(action: {
                self.managedObjectContext.delete(self.shoppingItem)
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
            .background(Rectangle().cornerRadius(16).padding(.horizontal)
            .foregroundColor(Color("cellColor"))
            )
            .padding(.bottom)
        }
    
        
    }
}

