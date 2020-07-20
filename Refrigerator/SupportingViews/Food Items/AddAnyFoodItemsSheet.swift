//
//  AddAnyFoodItemsSheet.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/19/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import Vision
import VisionKit

struct AddAnyFoodItemsSheet: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingView: String?
    @Binding var scan: VNDocumentCameraScan?
    @Binding var image: [CGImage]?
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: AddFoodItemsListView().environment(\.managedObjectContext, self.moc), label: {
                    Image("SelectFromListButton").renderingMode(.original)
                    }).padding()
//                NavigationLink(destination: AddFoodItemSheet(), label: {
//                Image("EnterManuallyButton").renderingMode(.original)
//                }).padding()
                //TODO: add more options
                Button(action: {
                    self.showingView = "scanner"
                    
                }, label: {
                    Image("scan reciept button")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        
                }).padding(6)
                
            }.onReceive(NotificationCenter.default.publisher(for: .addSelecedFoodItems)) {_ in

                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.presentationMode.wrappedValue.dismiss()
               }
            }
        }
    }
}
