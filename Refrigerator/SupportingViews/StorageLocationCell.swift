//
//  StorageLocationCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/4/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct StorageLocationCell: View {
    
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.name, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isShowingActionSheet = false
    var storageLocationIcon: String
    var storageLocationNumberOfItems: Int
    var storageLocationTitle: String
    var storage: StorageLocation
    var body: some View {
         HStack {
                
                   HStack {
                    Image(storageLocationIcon)
                        .padding(.horizontal)
                           
                       VStack {
                        HStack {
                            Text("\(String(storageLocationNumberOfItems)) items")
                                .font(.custom("SF Pro Text", size: 16))
                            .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                           HStack {
                            Text(storageLocationTitle)
                                   .font(.custom("SF Pro Text", size: 23))
                                   .multilineTextAlignment(.leading)
                               Spacer()
                           }
                            .padding(.bottom)
                           
                       }
                       Spacer()
                    Button(action: {self.isShowingActionSheet.toggle()}, label: {
                        Image(systemName: "minus.circle")
                            .renderingMode(.original)
                        .padding()
                        
                    })
                       }
                   .padding()
                   .background(Image("Rectangle").resizable().padding(.horizontal))
                   .padding(.bottom)
               }        .actionSheet(isPresented: $isShowingActionSheet, content: {
                  ActionSheet(title: Text("Delete?"), message: Text("Are you sure you want to delete this Storage Location?"), buttons: [
                      .default(Text("Yes"), action: {
                        let foodItems = self.foodItem[0]
                        self.managedObjectContext.delete(self.storage)
                          try? self.managedObjectContext.save()
                  })
                      ,.default(Text("No"))
                  ])
               })

    }
}


