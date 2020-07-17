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
import UserNotifications
func addDays (days: Int, dateCreated: Date) -> Date{
    let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
    print("Modified date: \(modifiedDate)")
    return modifiedDate
}
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
            .padding()
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

                }).padding()
            Spacer()
            HStack{
                Text("Lasts for ")
                Picker(selection: self.$lastsFor, label: Text("Picker")) {
                    ForEach(1...366,id: \.self){ numb in
                        Text("\(numb)").tag(numb)
                    }
                }.frame(width: 100, height: 100)
                    
                Text(" days")
                
            }.padding()
            Spacer()
               Button(action: {
                let id = UUID()
                   let newFoodItem = FoodItem(context: self.managedObjectContext)
                newFoodItem.staysFreshFor = Int16(self.lastsFor)
                newFoodItem.symbol = self.selectedEmoji
                newFoodItem.name = self.nameOfFood
                newFoodItem.inStorageSince = Date()
                newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                newFoodItem.origion?.storageName = self.storage.wrappedStorageName
                newFoodItem.origion?.symbolName = self.storage.wrappedSymbolName
                newFoodItem.id = id
                
                Analytics.logEvent("addedFoodItem", parameters: nil)
                   do{
                       try self.managedObjectContext.save()
                   } catch let error{
                   print(error)
                   }
                addToDailyGoal()
                refreshDailyGoalAndStreak()
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = "Eat This Food Soon"
                let date = Date()
                let twoDaysBefore = addDays(days: self.lastsFor - 2, dateCreated: date)
                content.body = "Your food item, \(newFoodItem.wrappedName) is about to go bad in 2 days."
                content.sound = UNNotificationSound.default
                var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: twoDaysBefore)
                dateComponents.hour = 10
                dateComponents.minute = 0
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                print("dateComponents for notifs: \(dateComponents)")
                let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
                center.add(request)
                
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
