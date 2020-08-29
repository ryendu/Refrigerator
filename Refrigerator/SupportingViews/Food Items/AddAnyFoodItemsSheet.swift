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
    @FetchRequest(entity: User.entity(),sortDescriptors: []) var user: FetchedResults<User>
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    var body: some View {
        NavigationView{
            VStack{
                if self.refrigeratorViewModel.isPremiumPurchased() == true{
                NavigationLink(destination: AddFoodItemsListView().environment(\.managedObjectContext, self.moc), label: {
                    Image("SelectFromListButton").renderingMode(.original)
                    }).padding()
                }else {
                    Image("SelectFromListButton").renderingMode(.original).overlay(RoundedRectangle(cornerRadius: 19).foregroundColor(Color("whiteAndBlack")).opacity(0.4)).padding()
                    NavigationLink(destination: PremiumView()){
                        Text("Only avalible for premium users").font(.caption)
                    }.padding()
                    
                }
                NavigationLink(destination: AddFoodItemSheet(), label: {
                Image("EnterManuallyButton").renderingMode(.original)
                }).padding()
                //TODO: add more options
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.showingView = "scanner"
                }, label: {
                    Image("scan reciept button").renderingMode(.original)
                }).padding(6)
                
            }.onReceive(NotificationCenter.default.publisher(for: .addSelecedFoodItems)) {_ in

                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.presentationMode.wrappedValue.dismiss()
               }
            }
            .onReceive(NotificationCenter.default.publisher(for: .dismissAddAnyFoodSheet)) {_ in

                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.presentationMode.wrappedValue.dismiss()
               }
            }
            .navigationBarTitle(Text("Add A Food Item"))
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel").foregroundColor(.orange)
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
