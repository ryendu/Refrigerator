//
//  StorageCellFoodPlannerSelection.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/17/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct StorageCellFoodPlannerSelection: View {
        @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @Environment(\.managedObjectContext) var managedObjectContext
    var storageLocationIcon: String
    var storageLocationNumberOfItems: Int
    var storageLocationTitle: String
    var storage: StorageLocation
    @Binding var showAllFoods: Bool
    var body: some View {
         HStack {
                
                   HStack {
                    Image(storageLocationIcon)
                        .padding(.horizontal)
                           
                       VStack {
                        HStack {
                            Text("\(String(storageLocationNumberOfItems)) items")
                                .font(.custom("SFProDisplay", size: 16))
                            .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                           HStack {
                            Text(storageLocationTitle)
                                   .font(.custom("SFProDisplay", size: 23))
                                   .multilineTextAlignment(.leading)
                               Spacer()
                           }
                            .padding(.bottom)
                           
                       }
                       Spacer()
                    
                    Image(systemName: "chevron.up")
                    .rotationEffect(Angle(degrees: self.showAllFoods ? 180 : 0))
                    .padding()
                       }
                   .padding()
                   .background(Rectangle().cornerRadius(16).padding(.horizontal)
                   .foregroundColor(Color("whiteAndGray"))
                   .shadow(color: Color("shadows"), radius: 3)
                   )
                   .padding(.bottom)
               }

    }
}
