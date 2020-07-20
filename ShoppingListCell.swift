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
    @State var press = false
    @State var image: Image? = nil
    var body: some View {
        
        HStack {
            Button(action: {
                withAnimation(){
                    self.shoppingItem.checked.toggle()
                }
            }, label: {
                PercentageRing(ringWidth: 6, percent: self.shoppingItem.checked ? 150 : 0, backgroundColor: Color.orange.opacity(0.2), foregroundColors: [Color(hex: "FAD961"), Color(hex: "F76B1C")])
                    .frame(width: 28, height: 28)
                    .animation(.spring())
                    .padding()
            })
            
            HStack {
                if shoppingItem.usesImage == false{
                    Text(icon)
                        .font(.largeTitle)
                        .padding(.leading, 8)
                }
                else {
                    if self.image != nil{
                        self.image!
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    
                    }
                }
                VStack {
                    HStack {
                        Text(title)
                            .font(.custom("SFProDisplay", size: 16))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                }
                Spacer()
                }
            
        }.padding()
        .background(Rectangle().cornerRadius(16).padding(.horizontal)
        .foregroundColor(Color("whiteAndGray"))
        )
            .onAppear{
                if self.shoppingItem.usesImage{
                    self.image = Image(uiImage: UIImage(data: self.shoppingItem.image) ?? UIImage(named: "Fridge icon")!)
                }
        }
        .padding(.bottom)
        .shadow(color: Color("shadows"), radius: 4)
        
    
        
    }
}

