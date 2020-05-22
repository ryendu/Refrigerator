//
//  AddFoodItemSheet.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/5/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct AddFoodItemSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)]) var foodItem: FetchedResults<FoodItem>
    var storage: StorageLocation
    @State var lastsFor = 7
    @State var selectedEmoji = ""
    @State var nameOfFood = ""
    @State var listOfEmojis1 = [emoji(emoji: "🍏"), emoji(emoji: "🍎"), emoji(emoji: "🍐"),emoji(emoji: "🍊"),emoji(emoji: "🍋"),emoji(emoji: "🍌"),emoji(emoji: "🍉"),emoji(emoji: "🍇"),emoji(emoji: "🍓"),emoji(emoji: "🍈"),emoji(emoji: "🍒"),emoji(emoji: "🍑"),emoji(emoji: "🥭"),emoji(emoji: "🍍"),emoji(emoji: "🥥"),emoji(emoji: "🥝"),emoji(emoji: "🍅"),emoji(emoji: "🍆"),emoji(emoji: "🥑"),emoji(emoji: "🥦"),emoji(emoji: "🥬"),emoji(emoji: "🥒"),emoji(emoji: "🌶"),emoji(emoji: "🌽"),emoji(emoji: "🥕"),emoji(emoji: "🧄"),emoji(emoji: "🥔"),emoji(emoji: "🍠"),emoji(emoji: "🥐"),emoji(emoji: "🥯"),emoji(emoji: "🍞"),emoji(emoji: "🥖"),emoji(emoji: "🥨"),emoji(emoji: "🧀"),emoji(emoji: "🥚")]
       
       @State var listOfEmojis2 = [emoji(emoji: "🍳"),emoji(emoji: "🧈"),emoji(emoji: "🥞"),emoji(emoji: "🧇"),emoji(emoji: "🥓"),emoji(emoji: "🥩"),emoji(emoji: "🍗"),emoji(emoji: "🍖"),emoji(emoji: "🦴"),emoji(emoji: "🌭"),emoji(emoji: "🍔"),emoji(emoji: "🍟"),emoji(emoji: "🍕"),emoji(emoji: "🥪"),emoji(emoji: "🥙"),emoji(emoji: "🧆"),emoji(emoji: "🌮"),emoji(emoji: "🌯"),emoji(emoji: "🥗"),emoji(emoji: "🥘"),emoji(emoji: "🥫"),emoji(emoji: "🍝"),emoji(emoji: "🍜"),emoji(emoji: "🍲"),emoji(emoji: "🍛"),emoji(emoji: "🍣"),emoji(emoji: "🍱"),emoji(emoji: "🥟"),emoji(emoji: "🍙"),emoji(emoji: "🍚"),emoji(emoji: "🍘"),emoji(emoji: "🍥"),emoji(emoji: "🥠"),emoji(emoji: "🥮"),emoji(emoji: "🍢")]
       
       @State var listOfEmojis3 = [emoji(emoji: "🍡"),emoji(emoji: "🍧"),emoji(emoji: "🍨"),emoji(emoji: "🍦"),emoji(emoji: "🥧"),emoji(emoji: "🧁"),emoji(emoji: "🍰"),emoji(emoji: "🎂"),emoji(emoji: "🍮"),emoji(emoji: "🍭"),emoji(emoji: "🍬"),emoji(emoji: "🍫"),emoji(emoji: "🍿"),emoji(emoji: "🍩"),emoji(emoji: "🍪"),emoji(emoji: "🌰"),emoji(emoji: "🥜"),emoji(emoji: "🍯"),emoji(emoji: "🥛"),emoji(emoji: "🍼"),emoji(emoji: "☕️"),emoji(emoji: "🍵"),emoji(emoji: "🧃"),emoji(emoji: "🥤"),emoji(emoji: "🍶"),emoji(emoji: "🍺"),emoji(emoji: "🍻"),emoji(emoji: "🥂"),emoji(emoji: "🍷"),emoji(emoji: "🥃"),emoji(emoji: "🍸"),emoji(emoji: "🍹"),emoji(emoji: "🧉"),emoji(emoji: "🍾"),emoji(emoji: "🧊")]
           
           
       
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
                var tempNumberOfFoodOrder = Int()
                   let newFoodItem = FoodItem(context: self.managedObjectContext)
                newFoodItem.staysFreshFor = Int16(self.lastsFor)
                newFoodItem.symbol = self.selectedEmoji
                newFoodItem.name = self.nameOfFood
                newFoodItem.inStorageSince = Date()
                newFoodItem.order = Int32(UserDefaults.standard.integer(forKey: "foodOrder"))
                tempNumberOfFoodOrder = UserDefaults.standard.integer(forKey: "foodOrder")
                print("The food item \(self.nameOfFood) has a order of \(UserDefaults.standard.integer(forKey: "foodOrder"))")
                UserDefaults.standard.set(tempNumberOfFoodOrder + 1, forKey: "foodOrder")
                
                //If these lines are gotten rid of then the second copy of the storageLocation will not appear and neither will the food item anywhere
                newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                newFoodItem.origion?.storageName = self.storage.wrappedStorageName
                newFoodItem.origion?.symbolName = self.storage.wrappedSymbolName
                
                   
                   do{
                       try self.managedObjectContext.save()
                   } catch let error{
                   print(error)
                   }
                   self.presentationMode.wrappedValue.dismiss()
                }, label: {Image("add").renderingMode(.original)}).padding()
           }
           
       }
}


extension Date {
    func adding(days: Int) -> Date? {
        let result =  Calendar.current.date(byAdding: .day, value: days, to: self)
        return result
    }
}
