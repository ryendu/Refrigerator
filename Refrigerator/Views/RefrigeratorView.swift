//
//  RefrigeratorView.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/2/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData
import Firebase
import Vision
import VisionKit

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
    func possiblyDoSomething(withPercentAsDecimal percent: Double) -> Bool{
        func simplify(top:Int, bottom:Int) -> (newTop:Int, newBottom:Int) {

            var x = top
            var y = bottom
            while (y != 0) {
                let buffer = y
                y = x % y
                x = buffer
            }
            let hcfVal = x
            let newTopVal = top/hcfVal
            let newBottomVal = bottom/hcfVal
            return(newTopVal, newBottomVal)
        }
        let denomenator = simplify(top:Int(percent * 100), bottom: 100)
        var returnValue = false
        print(denomenator)
        if Int.random(in: 1...denomenator.newBottom) == 1 {
        returnValue = true
      }
       return returnValue
    }
    @Binding var showingView: String?
    @Binding var scan: VNDocumentCameraScan?
    @Binding var image: [CGImage]?
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isShowingActionSheet = false
    @State var indexOfDelete = 0
    

    var body: some View {
                
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    
                    
                    if storageLocation.count > 0{
                    ForEach(self.storageLocation, id: \.self) { item in
                                                
                        NavigationLink(destination: IndivisualRefrigeratorView(storageIndex: item, showingView: self.$showingView, scan: self.$scan, image: self.$image ).environment(\.managedObjectContext, self.managedObjectContext)) {
                            StorageLocationCell(storageLocationIcon: item.wrappedSymbolName, storageLocationNumberOfItems: item.foodItemArray.count, storageLocationTitle: item.wrappedStorageName, storage: item).environment(\.managedObjectContext, self.managedObjectContext)
                            }.buttonStyle(PlainButtonStyle())


                    }
                    } else {
                        Text("Start by adding a new Storage location with the plus button above").padding()
                    }
                    
                }
                    .navigationBarTitle("Refrigerator View")
                    .navigationBarItems(trailing:
                    Button(action: {
                        
                        self.refrigeratorViewModel.isInStorageItemAddingView.toggle()
                    }, label: {
                        Image("plus")
                            .renderingMode(.original)
                    }))
                    

            })
            
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $refrigeratorViewModel.isInStorageItemAddingView, content: {
                AddToStorageItemSheet().environmentObject(refrigerator).environment(\.managedObjectContext, self.managedObjectContext)
            })
        

        
    }
}
