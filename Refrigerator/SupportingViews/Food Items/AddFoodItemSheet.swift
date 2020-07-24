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
    @State var storage: StorageLocation? = nil
    @State var showStorageNilError = false
    @FetchRequest(entity: StorageLocation.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @FetchRequest(entity: User.entity(),sortDescriptors: []) var user: FetchedResults<User>

    @State var lastsFor = 7
    @State var selectedEmoji = ""
    @State var nameOfFood = ""
    
    @State var listOfEmojis1 = [emoji(emoji: "🍏"), emoji(emoji: "🍎"), emoji(emoji: "🍐"),emoji(emoji: "🍊"),emoji(emoji: "🍋"),emoji(emoji: "🍌"),emoji(emoji: "🍉"),emoji(emoji: "🍇"),emoji(emoji: "🍓"),emoji(emoji: "🍈"),emoji(emoji: "🍒"),emoji(emoji: "🍑"),emoji(emoji: "🥭"),emoji(emoji: "🍍"),emoji(emoji: "🥥"),emoji(emoji: "🥝"),emoji(emoji: "🍅"),emoji(emoji: "🍆"),emoji(emoji: "🥑"),emoji(emoji: "🥦"),emoji(emoji: "🥬"),emoji(emoji: "🥒"),emoji(emoji: "🌶"),emoji(emoji: "🌽"),emoji(emoji: "🥕"),emoji(emoji: "🧄")]
    
    @State var listOfEmojis2 = [emoji(emoji: "🍳"),emoji(emoji: "🧈"),emoji(emoji: "🥞"),emoji(emoji: "🧇"),emoji(emoji: "🥓"),emoji(emoji: "🥩"),emoji(emoji: "🍗"),emoji(emoji: "🍖"),emoji(emoji: "🦴"),emoji(emoji: "🌭"),emoji(emoji: "🍔"),emoji(emoji: "🍟"),emoji(emoji: "🍕"),emoji(emoji: "🥪"),emoji(emoji: "🥙"),emoji(emoji: "🧆"),emoji(emoji: "🌮"),emoji(emoji: "🌯"),emoji(emoji: "🥗"),emoji(emoji: "🥘"),emoji(emoji: "🥫"),emoji(emoji: "🍝"),emoji(emoji: "🍜"),emoji(emoji: "🍲"),emoji(emoji: "🍛"),emoji(emoji: "🍣")]
    
    @State var listOfEmojis3 = [emoji(emoji: "🍡"),emoji(emoji: "🍧"),emoji(emoji: "🍨"),emoji(emoji: "🍦"),emoji(emoji: "🥧"),emoji(emoji: "🧁"),emoji(emoji: "🍰"),emoji(emoji: "🎂"),emoji(emoji: "🍮"),emoji(emoji: "🍭"),emoji(emoji: "🍬"),emoji(emoji: "🍫"),emoji(emoji: "🍿"),emoji(emoji: "🍩"),emoji(emoji: "🍪"),emoji(emoji: "🌰"),emoji(emoji: "🥜"),emoji(emoji: "🍯"),emoji(emoji: "🥛"),emoji(emoji: "🍼"),emoji(emoji: "☕️"),emoji(emoji: "🍵"),emoji(emoji: "🧃"),emoji(emoji: "🥤"),emoji(emoji: "🍶"),emoji(emoji: "🍺")]
    @State var listOfEmojis4 = [emoji(emoji: "🥔"),emoji(emoji: "🍠"),emoji(emoji: "🥐"),emoji(emoji: "🥯"),emoji(emoji: "🍞"),emoji(emoji: "🥖"),emoji(emoji: "🥨"),emoji(emoji: "🧀"),emoji(emoji: "🥚"),emoji(emoji: "🍱"),emoji(emoji: "🥟"),emoji(emoji: "🍙"),emoji(emoji: "🍚"),emoji(emoji: "🍘"),emoji(emoji: "🍥"),emoji(emoji: "🥠"),emoji(emoji: "🥮"),emoji(emoji: "🍢"),emoji(emoji: "🍻"),emoji(emoji: "🥂"),emoji(emoji: "🍷"),emoji(emoji: "🥃"),emoji(emoji: "🍸"),emoji(emoji: "🍹"),emoji(emoji: "🧉"),emoji(emoji: "🍾"),emoji(emoji: "🧊")
    ]
func possiblyDoSomething(withPercentAsDecimal percent: Double) -> Bool{
    func contains(x: Int, numerator: Int)-> Bool{
        var returnObj = false
        for index in 1...numerator{
            if index == x{
                returnObj = true
            }
        }
        return returnObj
    }
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
    if contains(x: Int.random(in: 1...denomenator.newBottom), numerator: denomenator.newTop) {
    returnValue = true
  }
   return returnValue
}
    @State var selectionIndx = 0
    
    var body: some View {
        ScrollView{
            VStack {
                
                HStack {
                    Text("Whats the name of this food")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding()
                        .multilineTextAlignment(.leading)
                    Spacer()
                }.padding(.horizontal)
                
                TextField("name of Food item", text: $nameOfFood)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                
                HStack {
                    Text("chose an emoji for this food")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding()
                    Spacer()
                }.padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: true, content: {
                    VStack {
                        HStack{
                            ForEach(listOfEmojis1, id: \.self) {emoji in
                                
                                Button(action: {self.selectedEmoji = emoji.emoji}, label:{
                                    if self.selectedEmoji == emoji.emoji{
                                        Text(emoji.emoji)
                                            .font(.system(size: 20))
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
                                            .font(.system(size: 20))
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
                                            .font(.system(size: 20))
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
                            ForEach(listOfEmojis4, id: \.self) {emoji in
                                
                                Button(action: {self.selectedEmoji = emoji.emoji}, label:{
                                    if self.selectedEmoji == emoji.emoji{
                                        Text(emoji.emoji)
                                            .font(.system(size: 20))
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
                Group{
                    Spacer()
                    HStack{
                        Text("How Long Does This Food last for?")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding()
                        Spacer()
                    }
                    HStack{
                        Text("Lasts for ")
                        Picker(selection: self.$lastsFor, label: Text("Picker")) {
                            ForEach(1...999,id: \.self){ numb in
                                Text("\(numb)").tag(numb)
                            }
                            }.labelsHidden().frame(width: 100, height: 100)
                        
                        Text(" days")
                        
                    }.padding()
                    HStack{
                        Text("Pick a storage Location")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding()
                        Spacer()
                    }
                    Picker(selection: self.$selectionIndx, label: Text("Pick a storage Location")) {
                        ForEach(0...self.storageLocation.count - 1, id: \.self){ index in
                            Text(self.storageLocation[index].wrappedStorageName).tag(index)
                        }
                    }.labelsHidden().frame(width: 100, height: 100)
                    
                    
                    if self.showStorageNilError{
                        Text("Please select a storage location to add this item to").foregroundColor(.red).padding()
                    }
                    
                    Spacer()
                    Button(action: {
                        self.storage = self.storageLocation[self.selectionIndx]
                        if let storg = self.storage{
                            self.showStorageNilError = false
                            let id = UUID()
                            let newFoodItem = FoodItem(context: self.managedObjectContext)
                            newFoodItem.staysFreshFor = Int16(self.lastsFor)
                            newFoodItem.symbol = self.selectedEmoji
                            newFoodItem.name = self.nameOfFood
                            newFoodItem.inStorageSince = Date()
                            newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                            newFoodItem.origion?.storageName = storg.wrappedStorageName
                            newFoodItem.origion?.symbolName = storg.wrappedSymbolName
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
                            let twoDaysBefore = addDays(days: 7 - Int(self.user.first?.remindDate ?? Int16(2)), dateCreated: date)
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
                            NotificationCenter.default.post(name: .dismissAddAnyFoodSheet, object: nil)
                        }else {
                            self.showStorageNilError = true
                        }
                    }, label: {Image("addOrange").renderingMode(.original)}).padding()
                    
                    if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 6 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)) && self.refrigeratorViewModel.isPremiumPurchased() == false{
                        GADBannerViewController()
                            .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                    }else {
                        
                    }}
                
            }
        }.navigationBarTitle(Text("Add A Food Manually"))
        .navigationBarItems(trailing: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel").foregroundColor(.orange)
        }).padding())
    }
}


extension Date {
    func adding(days: Int) -> Date? {
        let result =  Calendar.current.date(byAdding: .day, value: days, to: self)
        return result
    }
}

 extension Notification.Name {

    static var dismissAddAnyFoodSheet: Notification.Name {
        return Notification.Name("dismissAddAnyFoodSheet")
    }
}
