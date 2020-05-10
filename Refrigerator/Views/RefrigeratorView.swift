//
//  RefrigeratorView.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/2/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData
enum storageLocationIcons: String {
    case fridgeGreen = "Fridge pastel icon green"
    case fridgeOrange = "Fridge pastel icon orange"
    case fridgeRed = "Fridge pastel icon red"
    case fridgePurple = "Fridge pastel icon purple"
    case fridgeYellow = "Fridge pastel icon yellow"
    case fridgeTurquoise = "Fridge pastel icon turquoise"
    case pantryGreen = "pantry green"
    case pantryOrange = "pantry orange"
    case pantryRed = "pantry red"
    case pantryPurple = "pantry purple"
    case pantryYellow = "pantry yellow"
    case pantryTurquoice = "pantry turquoise"
}

struct RefrigeratorView: View {
    
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: []) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isShowingActionSheet = false
    @State var indexOfDelete = 0
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    HStack {
                        Text("Hi, \(UserDefaults.standard.string(forKey: "name")!)")
                            .font(.custom("SF Compact Display", size: 38))
                            .padding()
                        Button(action: {
                            self.refrigeratorViewModel.isInStorageItemAddingView.toggle()
                        }, label: {
                            Image("plus")
                                .renderingMode(.original)
                        })
                    }
                    
                    ForEach(self.storageLocation, id: \.self) { item in
                        
                        //TODO: CHANGE the storage Location Number Of Items
                        
                        NavigationLink(destination: IndivisualRefrigeratorView(storageIndex: item).environment(\.managedObjectContext, self.managedObjectContext)) {
                            StorageLocationCell(storageLocationIcon: item.wrappedSymbolName, storageLocationNumberOfItems: 0, storageLocationTitle: item.wrappedStorageName).environment(\.managedObjectContext, self.managedObjectContext)
                        }.buttonStyle(PlainButtonStyle())


                    }
                    
                    
                }

            })
            
        }.sheet(isPresented: $refrigeratorViewModel.isInStorageItemAddingView, content: {
            AddToStorageItemSheet().environmentObject(refrigerator).environment(\.managedObjectContext, self.managedObjectContext)
        })

        
    }
}

struct RefrigeratorView_Previews: PreviewProvider {
    static var previews: some View {
        RefrigeratorView().environmentObject(refrigerator)
    }
}
