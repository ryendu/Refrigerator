//
//  AddToStorageItemSheet.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/5/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData
import Foundation
import GoogleMobileAds
import Firebase

struct AddToStorageItemSheet: View {
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

    @Environment(\.presentationMode) var presentationMode

    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    var listOfIcons1 = [storageLocationIcons.fridgeGreen, .fridgeTurquoise,.fridgeOrange,.fridgePurple,.fridgeRed,.fridgeYellow]
    var listOfIcons2 = [storageLocationIcons.pantryPurple,.pantryTurquoice,.pantryYellow,.pantryOrange,.pantryGreen,.pantryRed]
    @State var storageType: String = DefaultStorageLocation.refrigerator.rawValue
       @State var nameOfStorageLocation = ""
    @State var isDefaultStorage = false
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    @State var selectedIcon = storageLocationIcons.fridgeGreen
       var body: some View {
        ScrollView{
           VStack {
            HStack{
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel").foregroundColor(.orange)
                    }).padding()
            }
               Text("Add A Storage Location")
                   .font(.largeTitle)
                   .layoutPriority(1)
               HStack {
                   Text("Name your Storage Location")
                       .multilineTextAlignment(.leading)
                   Spacer()
               }.padding(.horizontal)
                   
               TextField("name of Storage Location", text: $nameOfStorageLocation)
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .padding(.horizontal, 40)
               
               HStack {
                   Text("chose an icon for this Storage Location")
                   Spacer()
               }.padding(.horizontal)
               ScrollView(.horizontal, showsIndicators: true, content: {

                       HStack{
ForEach(listOfIcons1, id: \.self) {emoji in

    Button(action: {self.selectedIcon = emoji}, label:{
        if self.selectedIcon == emoji{
            Image(emoji.rawValue)
                .renderingMode(.original)
            .padding()
                .background(Image("Rectangle")
                    .resizable()
                    .renderingMode(.original)
            )

        }else {
            Image(emoji.rawValue)
                .renderingMode(.original)
            .padding()
        }
    })
}
}.padding()
                HStack{
                ForEach(listOfIcons2, id: \.self) {emoji in

                    Button(action: {self.selectedIcon = emoji}, label:{
                        if self.selectedIcon == emoji{
                            Image(emoji.rawValue)
                                .renderingMode(.original)
                                .padding()
                                .background(Image("Rectangle")
                                    .resizable()
                                    .renderingMode(.original)
                            )

                        }else {
                            Image(emoji.rawValue)
                                .renderingMode(.original)
                            .padding()
                        }
                    })
                }
                }.padding()
                
                    

               })
               
            Picker(selection: self.$storageType, label: Text("Type of Storage")){
                Text("Refrigerator").tag(DefaultStorageLocation.refrigerator.rawValue)
                Text("Freezer").tag(DefaultStorageLocation.freezer.rawValue)
                Text("Pantry").tag(DefaultStorageLocation.pantry.rawValue)
            }.pickerStyle(SegmentedPickerStyle()).labelsHidden().padding()
            
            
            if self.storageType == DefaultStorageLocation.refrigerator.rawValue{
                if self.user.first?.defaultFridge != nil{
                Toggle(isOn: self.$isDefaultStorage) {
                    Text("Set as default Refrigerator?")
                }.padding()
                }else {
                    Toggle(isOn: self.$isDefaultStorage, label: {
                        Text("This will be set as your default Refrigerator")
                    }).disabled(true).padding()
                    .onAppear {
                        self.isDefaultStorage = true
                    }
                }
            }else if self.storageType == DefaultStorageLocation.freezer.rawValue{
                if self.user.first?.defaultFreezer != nil{
                Toggle(isOn: self.$isDefaultStorage) {
                    Text("Set as default Freezer?")
                }.padding()
                }else {
                    Toggle(isOn: self.$isDefaultStorage, label: {
                        Text("This will be set as your default Freezer")
                    }).disabled(true).padding()
                    .onAppear {
                        self.isDefaultStorage = true
                    }
                }
            } else {
                if self.user.first?.defaultPantry != nil{
                Toggle(isOn: self.$isDefaultStorage) {
                    Text("Set as default Pantry?")
                }.padding()
                }else {
                    Toggle(isOn: self.$isDefaultStorage, label: {
                        Text("This will be set as your default Pantry")
                    }).disabled(true).padding()
                    .onAppear {
                        self.isDefaultStorage = true
                    }
                }
            }
            
               Button(action: {

                let newStorageLocation = StorageLocation(context: self.managedObjectContext)
                newStorageLocation.storageName = self.nameOfStorageLocation
                newStorageLocation.symbolName = self.selectedIcon.rawValue
                if self.isDefaultStorage{
                    if self.storageType == DefaultStorageLocation.refrigerator.rawValue{
                        self.user.first?.defaultFridge = newStorageLocation
                    }else if self.storageType == DefaultStorageLocation.freezer.rawValue{
                        self.user.first?.defaultFreezer = newStorageLocation
                    } else {
                        self.user.first?.defaultPantry = newStorageLocation
                    }
                }
                do{
                    try self.managedObjectContext.save()
                } catch let error{
                print(error)
                }
                
                
                
                self.presentationMode.wrappedValue.dismiss()
               
               }, label: {Image("addOrange").renderingMode(.original)})
            
            if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 4 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)){
            GADBannerViewController()
            .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
            }else {

            }
        }
        }
       }
}

struct AddToStorageItemSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddToStorageItemSheet()
    }
}
