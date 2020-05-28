//
//  AddFoodItemSheet.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/5/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleMobileAds

struct AddFoodItemSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    var storage: StorageLocation
    @State var lastsFor = 7
    @State var selectedEmoji = ""
    @State var nameOfFood = ""
    @State var listOfEmojis1 = [emoji(emoji: "🍏"), emoji(emoji: "🍎"), emoji(emoji: "🍐"),emoji(emoji: "🍊"),emoji(emoji: "🍋"),emoji(emoji: "🍌"),emoji(emoji: "🍉"),emoji(emoji: "🍇"),emoji(emoji: "🍓"),emoji(emoji: "🍈"),emoji(emoji: "🍒"),emoji(emoji: "🍑"),emoji(emoji: "🥭"),emoji(emoji: "🍍"),emoji(emoji: "🥥"),emoji(emoji: "🥝"),emoji(emoji: "🍅"),emoji(emoji: "🍆"),emoji(emoji: "🥑"),emoji(emoji: "🥦"),emoji(emoji: "🥬"),emoji(emoji: "🥒"),emoji(emoji: "🌶"),emoji(emoji: "🌽"),emoji(emoji: "🥕"),emoji(emoji: "🧄"),emoji(emoji: "🥔"),emoji(emoji: "🍠"),emoji(emoji: "🥐"),emoji(emoji: "🥯"),emoji(emoji: "🍞"),emoji(emoji: "🥖"),emoji(emoji: "🥨"),emoji(emoji: "🧀"),emoji(emoji: "🥚")]
       
       @State var listOfEmojis2 = [emoji(emoji: "🍳"),emoji(emoji: "🧈"),emoji(emoji: "🥞"),emoji(emoji: "🧇"),emoji(emoji: "🥓"),emoji(emoji: "🥩"),emoji(emoji: "🍗"),emoji(emoji: "🍖"),emoji(emoji: "🦴"),emoji(emoji: "🌭"),emoji(emoji: "🍔"),emoji(emoji: "🍟"),emoji(emoji: "🍕"),emoji(emoji: "🥪"),emoji(emoji: "🥙"),emoji(emoji: "🧆"),emoji(emoji: "🌮"),emoji(emoji: "🌯"),emoji(emoji: "🥗"),emoji(emoji: "🥘"),emoji(emoji: "🥫"),emoji(emoji: "🍝"),emoji(emoji: "🍜"),emoji(emoji: "🍲"),emoji(emoji: "🍛"),emoji(emoji: "🍣"),emoji(emoji: "🍱"),emoji(emoji: "🥟"),emoji(emoji: "🍙"),emoji(emoji: "🍚"),emoji(emoji: "🍘"),emoji(emoji: "🍥"),emoji(emoji: "🥠"),emoji(emoji: "🥮"),emoji(emoji: "🍢")]
       
       @State var listOfEmojis3 = [emoji(emoji: "🍡"),emoji(emoji: "🍧"),emoji(emoji: "🍨"),emoji(emoji: "🍦"),emoji(emoji: "🥧"),emoji(emoji: "🧁"),emoji(emoji: "🍰"),emoji(emoji: "🎂"),emoji(emoji: "🍮"),emoji(emoji: "🍭"),emoji(emoji: "🍬"),emoji(emoji: "🍫"),emoji(emoji: "🍿"),emoji(emoji: "🍩"),emoji(emoji: "🍪"),emoji(emoji: "🌰"),emoji(emoji: "🥜"),emoji(emoji: "🍯"),emoji(emoji: "🥛"),emoji(emoji: "🍼"),emoji(emoji: "☕️"),emoji(emoji: "🍵"),emoji(emoji: "🧃"),emoji(emoji: "🥤"),emoji(emoji: "🍶"),emoji(emoji: "🍺"),emoji(emoji: "🍻"),emoji(emoji: "🥂"),emoji(emoji: "🍷"),emoji(emoji: "🥃"),emoji(emoji: "🍸"),emoji(emoji: "🍹"),emoji(emoji: "🧉"),emoji(emoji: "🍾"),emoji(emoji: "🧊")]
           
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
    
       
       var body: some View {
           VStack {
               Text("Add a food item")
                   .font(.largeTitle)
                   .layoutPriority(1)
               HStack {
                   Text("Whats the name of this food")
                       .multilineTextAlignment(.leading)
                   Spacer()
               }.padding(.horizontal)
                   
               TextField("name of Food item", text: $nameOfFood)
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .padding(.horizontal, 40)
               
               HStack {
                   Text("chose an emoji for this food")
                   Spacer()
               }.padding(.horizontal)
               ScrollView(.horizontal, showsIndicators: true, content: {
                   VStack {
                       HStack{
                       ForEach(listOfEmojis1, id: \.self) {emoji in
                           
                           Button(action: {self.selectedEmoji = emoji.emoji}, label:{
                               if self.selectedEmoji == emoji.emoji{
                                   Text(emoji.emoji)
                                       .background(Image("Rectangle")
                                           .resizable()
                                           .renderingMode(.original)
                                   )
                                   
                               }else {
                                   Text(emoji.emoji)
                               }
                           })
                       }
                       }.padding()
                       HStack{
                       ForEach(listOfEmojis2, id: \.self) {emoji in
                           
                           Button(action: {self.selectedEmoji = emoji.emoji}, label:{
                               if self.selectedEmoji == emoji.emoji{
                                   Text(emoji.emoji)
                                       .background(Image("Rectangle")
                                           .resizable()
                                           .renderingMode(.original)
                                   )
                                   
                               }else {
                                   Text(emoji.emoji)
                               }
                           })
                       }
                       }.padding()
                       HStack{
                       ForEach(listOfEmojis3, id: \.self) {emoji in
                           
                           Button(action: {self.selectedEmoji = emoji.emoji}, label:{
                               if self.selectedEmoji == emoji.emoji{
                                   Text(emoji.emoji)
                                       .background(Image("Rectangle")
                                           .resizable()
                                           .renderingMode(.original)
                                   )
                                   
                               }else {
                                   Text(emoji.emoji)
                               }
                           })
                       }
                       }.padding()
                   }

               })
            
            HStack{
                Text("Lasts for ")
                Picker(selection: self.$lastsFor, label: Text("Picker")) {
                    ForEach(1...366,id: \.self){ numb in
                        Text("\(numb)").tag(numb)
                    }
                }.frame(width: 100, height: 100)
                    
                Text(" days")
                
            }.padding()
               Button(action: {
                   let newFoodItem = FoodItem(context: self.managedObjectContext)
                newFoodItem.staysFreshFor = Int16(self.lastsFor)
                newFoodItem.symbol = self.selectedEmoji
                newFoodItem.name = self.nameOfFood
                newFoodItem.inStorageSince = Date()
                newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                newFoodItem.origion?.storageName = self.storage.wrappedStorageName
                newFoodItem.origion?.symbolName = self.storage.wrappedSymbolName
                newFoodItem.id = UUID()
                Analytics.logEvent("addedFoodItem", parameters: ["nameOfFood" : self.nameOfFood])
                   do{
                       try self.managedObjectContext.save()
                   } catch let error{
                   print(error)
                   }
                
                   self.presentationMode.wrappedValue.dismiss()
                }, label: {Image("addOrange").renderingMode(.original)}).padding()
            
            if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 6 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)){
            GADBannerViewController()
            .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
            }else {

            }
           }
           
       }
}


extension Date {
    func adding(days: Int) -> Date? {
        let result =  Calendar.current.date(byAdding: .day, value: days, to: self)
        return result
    }
}
