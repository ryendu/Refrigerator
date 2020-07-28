//
//  HomeView.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/28/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleMobileAds
import UIKit
import StoreKit
import UserNotifications
import CoreHaptics
import CoreData
import VisionKit
import Vision
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

struct ShoppingListItem: Hashable, Identifiable{
    var name: String
    var icon: String
    var id = UUID()
}
struct HomeView: View {
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    @State var ref: DocumentReference!
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
    @State var moveToStorageLocation: ShoppingList? = nil
    @State var shoppingListItemTapped: ShoppingList? = nil
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @FetchRequest(entity: StorageLocation.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @FetchRequest(entity: ShoppingList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingList.name, ascending: true)]) var shoppingList: FetchedResults<ShoppingList>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel

    @Binding var showingView: String?
    @Binding var scan: VNDocumentCameraScan?
    @Binding var image: [CGImage]?
    @State var showAddToShoppingListAlert: ShoppingListItem? = nil
    @State var showMoreInfoOnShoppingList = false
    @State var editFoodItem: FoodItem? = nil
    @State var shadowAmount = 0
    @State var showEatActionSheet = false
    @State var foodItemTapped: FoodItem? = nil
    @State var displayAmount = 0
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    @State var showMoreInfoOnFoodsToEatSoon = false
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                    ScrollView(.vertical, showsIndicators: false){
                        VStack {
                            VStack{
                             HomeViewDashboardFeatures(geo: geo, showingView: self.$showingView, scan: self.$scan, image: self.$image)
                            }
                            NavigationLink(destination: ExamineRecieptView(image: self.$image, showingView: self.$showingView, scan: self.$scan), tag: "results", selection: self.$showingView, label: {Text("")})
                            //MARK: FOODS TO EAT SOON
                            FoodsToEatSoonView(showAddToShoppingListAlert: self.$showAddToShoppingListAlert, foodItemTapped: self.$foodItemTapped, editFoodItem: self.$editFoodItem, geo: geo).padding()
                            
                            if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsInHomeView.rawValue) >= 2 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)) && self.refrigeratorViewModel.isPremiumPurchased() == false{
                                GADBannerViewController()
                                    .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                            }else {
                                
                            }
                            //MARK: SHOPPING LIST
                            
                            ShoppingListView(moveToStorageLocation: self.$moveToStorageLocation, shoppingListItemTapped: self.$shoppingListItemTapped)
                            
                            if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsInHomeView.rawValue) >= 1 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)) && self.refrigeratorViewModel.isPremiumPurchased() == false{
                                GADBannerViewController()
                                    .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                            }else {
                            }
                        }
                        
                        
                        
                        
                    }
                    if self.foodItemTapped != nil{
                        Text("")
                            .actionSheet(item: self.$foodItemTapped, content: { item in // << activated on item
                            ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this food item"), buttons: [
                                .default(Text("Eat All"), action: {
                                    self.user.first?.foodsEaten += Int32(1)
                                    let center = UNUserNotificationCenter.current()
                                    center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                                    self.showAddToShoppingListAlert = ShoppingListItem(name: item.wrappedName, icon: item.wrappedSymbol)
                                    self.managedObjectContext.delete(item)
                                    try? self.managedObjectContext.save()
                                    addToDailyGoal()
                                    refreshDailyGoalAndStreak()
                                    refreshDailyGoalAndStreak()
                                    
                                    
                                })
                                ,.default(Text("Throw Away"), action: {
                                    
                                    self.user.first?.foodsThrownAway += Int32(1)
                                    
                                    
                                    let center = UNUserNotificationCenter.current()
                                    center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                                    self.managedObjectContext.delete(item)
                                    try? self.managedObjectContext.save()
                                })
                                ,.default(Text("Eat Some"), action: {
                                    print("ate some of \(item)")
                                    addToDailyGoal()
                                    refreshDailyGoalAndStreak()
                                })
                                ,.default(Text("Edit"), action: {
                                    self.editFoodItem = item
                                    addToDailyGoal()
                                    refreshDailyGoalAndStreak()
                                })
                                
                                ,.default(Text("Duplicate"), action: {
                                    let id = UUID()
                                    let newFoodItem = FoodItem(context: self.managedObjectContext)
                                    newFoodItem.staysFreshFor = item.staysFreshFor
                                    if item.usesImage{
                                        newFoodItem.usesImage = true
                                        newFoodItem.image = item.image
                                    }else{
                                        newFoodItem.symbol = item.symbol
                                    }
                                    newFoodItem.name = item.name
                                    newFoodItem.inStorageSince = Date()
                                    newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                                    newFoodItem.origion?.storageName = item.origion?.storageName
                                    newFoodItem.origion?.symbolName = item.origion?.symbolName
                                    newFoodItem.id = id
                                    addToDailyGoal()
                                    refreshDailyGoalAndStreak()
                                    let center = UNUserNotificationCenter.current()
                                    let content = UNMutableNotificationContent()
                                    content.title = "Eat This Food Soon"
                                    let date = Date()
                                    let twoDaysBefore = self.addDays(days: Int(item.staysFreshFor) - Int(self.user.first?.remindDate ?? Int16(2)), dateCreated: date)
                                    content.body = "Your food item, \(newFoodItem.wrappedName) is about to go bad in 2 days."
                                    content.sound = UNNotificationSound.default
                                    var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: twoDaysBefore)
                                    dateComponents.hour = 10
                                    dateComponents.minute = 0
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                    print("dateComponents for notifs: \(dateComponents)")
                                    let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
                                    center.add(request)
                                    Analytics.logEvent("addedFoodItem", parameters: nil)
                                    do{
                                        try self.managedObjectContext.save()
                                    } catch let error{
                                        print(error)
                                    }
                                    
                                })
                                ,.default(Text("Cancel"))
                            ])
                        })
                    }
                    if self.shoppingListItemTapped != nil {
                        Text("")
                        .actionSheet(item: self.$shoppingListItemTapped, content: { item in // << activated on item
                            ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this shopping list item"), buttons: [
                                .default(Text("Delete"), action: {
                                    self.managedObjectContext.delete(item)
                                    try?self.managedObjectContext.save()
                                })
                                ,.default(Text("Duplicate"), action: {
                                    let newShoppingListItem = ShoppingList(context: self.managedObjectContext)
                                    newShoppingListItem.icon = item.wrappedIcon
                                    newShoppingListItem.name = item.wrappedName
                                    Analytics.logEvent("addedShoppingItem", parameters: nil)
                                    do{
                                        try self.managedObjectContext.save()
                                    } catch let error{
                                        print(error)
                                    }
                                    
                                }),
                                 .default(Text("Move to a storage location"), action: {
                                    self.moveToStorageLocation = item
                                 })
                                ,.default(Text("Cancel"))
                            ])
                        })
                    }
                                            
                
            }
            
            .navigationBarTitle("Hello, \(self.user.first?.name ?? "there")!")
            .onAppear(perform: {
                if self.user.first == nil {
                        let newUser = User(context: self.managedObjectContext)
                        newUser.name = ""
                        if UserDefaults.standard.string(forKey: "name") != "" {
                            newUser.name = UserDefaults.standard.string(forKey: "name")
                        }
                        newUser.foodsEaten = Int32(0)
                        newUser.foodsThrownAway = Int32(0)
                        newUser.dailyGoal = Int16(0)
                        newUser.streak = Int16(0)
                        try? self.managedObjectContext.save()
                    }else if self.user.count == 1{
                        
                    }else {
                        Analytics.logEvent("multipleUsersInCoredata", parameters: ["users": self.user.count])
                        for indx in 0...self.user.count - 1{
                            if indx != 0 {
                                self.managedObjectContext.delete(self.user[indx])
                                try? self.managedObjectContext.save()
                            }
                        }
                    }
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                        } else if let error = error {
                            print(error)
                            
                        }
                    }
                    
                    
                if RemoteConfigManager.boolValue(forkey: RCKeys.requestReview.rawValue) && self.user.first?.didReviewThisMonth == false{
                        rateApp()
                        
                        Analytics.logEvent("requestedReview", parameters: nil)
                    }
                })
        }
            
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}


struct ShoppingListView: View{
    @State var showMoreInfoOnShoppingList = false
    @Binding var moveToStorageLocation: ShoppingList?
    @Binding var shoppingListItemTapped: ShoppingList?
    @FetchRequest(entity: ShoppingList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingList.name, ascending: true)]) var shoppingList: FetchedResults<ShoppingList>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel

    var body: some View{
        VStack{
            Group{
                VStack(alignment: .leading){
                    HStack{
                        Text("Shopping List")
                            .font(.custom("SFCompactDisplay", size: 23))
                            .multilineTextAlignment(.leading)
                            .padding()
                        Button(action: {
                            withAnimation(){
                                self.showMoreInfoOnShoppingList.toggle()
                            }
                        }, label: {
                            Image(systemName: self.showMoreInfoOnShoppingList ? "questionmark.circle.fill":"questionmark.circle")
                        })
                        Spacer()
                        Group{
                        Button(action: {
                            
                            self.refrigeratorViewModel.isInShoppingListItemAddingView.toggle()
                        }, label: {
                            Image("plus")
                            }).padding()
                    }.padding(.horizontal)
                        
                }
                if self.showMoreInfoOnShoppingList{
                Text(RemoteConfigManager.stringValue(forkey: RCKeys.shoppingListDescriptionHomeView.rawValue))
                    .font(.custom("SFProDisplayLight", size: 18))
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color(hex: "878787"))
                    .animation(.spring())
                }
                Group{
                ForEach(self.shoppingList, id: \.self) { item in
                    
                    
                    ShoppingListCell(icon: item.wrappedIcon, title: item.wrappedName, shoppingItem: item)
                        .onTapGesture {
                            simpleSuccess()
                            self.shoppingListItemTapped = item
                    }
                    
                        
                    
                }
                    }
            }
        }
            if self.refrigeratorViewModel.isInShoppingListItemAddingView{
                Text("")
                .sheet(isPresented: self.$refrigeratorViewModel.isInShoppingListItemAddingView, content: {AddToShoppingListSheet().environmentObject(refrigerator).environment(\.managedObjectContext, self.managedObjectContext) })
                }
            if (self.moveToStorageLocation != nil){
                Text("")
            .sheet(item: self.$moveToStorageLocation, content: { _ in
                MoveShoppingItemToStorageSheet(Item: self.$moveToStorageLocation).environment(\.managedObjectContext, self.managedObjectContext).environmentObject(refrigerator)
            })
            }
        }
        
    }
}
struct HomeViewiPad: View {
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    @State var ref: DocumentReference!
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
    
    @FetchRequest(entity: StorageLocation.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @FetchRequest(entity: ShoppingList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingList.name, ascending: true)]) var shoppingList: FetchedResults<ShoppingList>
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>

        @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @Binding var showingView: String?
    @Binding var scan: VNDocumentCameraScan?
    @Binding var image: [CGImage]?
    @State var shadowAmount = 0
    @State var foodItemTapped: FoodItem? = nil
    @State var displayAmount = 0
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    @State var showMoreInfoOnShoppingList = false
    @State var showAddToShoppingListAlert: ShoppingListItem? = nil
    @State var editFoodItem: FoodItem? = nil

    
    @State var moveToStorageLocation: ShoppingList? = nil
    @State var shoppingListItemTapped: ShoppingList? = nil
    
    var body: some View {
            GeometryReader { geo in
                NavigationLink(destination: ExamineRecieptView(image: self.$image, showingView: self.$showingView, scan: self.$scan), tag: "results", selection: self.$showingView, label: {Text("")})
                    ScrollView(.vertical, showsIndicators: false){
                        VStack {
                             HomeViewDashboardFeatures(geo: geo, showingView: self.$showingView, scan: self.$scan, image: self.$image)
                            //MARK: FOODS TO EAT SOON
                            FoodsToEatSoonView(showAddToShoppingListAlert: self.$showAddToShoppingListAlert, foodItemTapped: self.$foodItemTapped, editFoodItem: self.$editFoodItem, geo: geo).padding()
                            if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsInHomeView.rawValue) >= 2 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)) && self.refrigeratorViewModel.isPremiumPurchased() == false{
                                GADBannerViewController()
                                    .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                            }else {
                                
                            }
                            //MARK: SHOPPING LIST
                            ShoppingListView(moveToStorageLocation: self.$moveToStorageLocation, shoppingListItemTapped: self.$shoppingListItemTapped).padding()
                            
                            if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsInHomeView.rawValue) >= 1 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)) && self.refrigeratorViewModel.isPremiumPurchased() == false{
                                GADBannerViewController()
                                    .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                            }else {
                            }
                        }
                        
                        
                        
                        
                    }
                if self.foodItemTapped != nil{
                    Text("")
                        .actionSheet(item: self.$foodItemTapped, content: { item in // << activated on item
                        ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this food item"), buttons: [
                            .default(Text("Eat All"), action: {
                                self.user.first?.foodsEaten += Int32(1)
                                let center = UNUserNotificationCenter.current()
                                center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                                self.showAddToShoppingListAlert = ShoppingListItem(name: item.wrappedName, icon: item.wrappedSymbol)
                                self.managedObjectContext.delete(item)
                                try? self.managedObjectContext.save()
                                addToDailyGoal()
                                refreshDailyGoalAndStreak()
                                refreshDailyGoalAndStreak()
                                
                                
                            })
                            ,.default(Text("Throw Away"), action: {
                                
                                self.user.first?.foodsThrownAway += Int32(1)
                                
                                
                                let center = UNUserNotificationCenter.current()
                                center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                                self.managedObjectContext.delete(item)
                                try? self.managedObjectContext.save()
                            })
                            ,.default(Text("Eat Some"), action: {
                                print("ate some of \(item)")
                                addToDailyGoal()
                                refreshDailyGoalAndStreak()
                            })
                            ,.default(Text("Edit"), action: {
                                self.editFoodItem = item
                                addToDailyGoal()
                                refreshDailyGoalAndStreak()
                            })
                            
                            ,.default(Text("Duplicate"), action: {
                                let id = UUID()
                                let newFoodItem = FoodItem(context: self.managedObjectContext)
                                newFoodItem.staysFreshFor = item.staysFreshFor
                                if item.usesImage{
                                    newFoodItem.usesImage = true
                                    newFoodItem.image = item.image
                                }else{
                                    newFoodItem.symbol = item.symbol
                                }
                                newFoodItem.name = item.name
                                newFoodItem.inStorageSince = Date()
                                newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                                newFoodItem.origion?.storageName = item.origion?.storageName
                                newFoodItem.origion?.symbolName = item.origion?.symbolName
                                newFoodItem.id = id
                                addToDailyGoal()
                                refreshDailyGoalAndStreak()
                                let center = UNUserNotificationCenter.current()
                                let content = UNMutableNotificationContent()
                                content.title = "Eat This Food Soon"
                                let date = Date()
                                let twoDaysBefore = self.addDays(days: Int(item.staysFreshFor) - Int(self.user.first?.remindDate ?? Int16(2)), dateCreated: date)
                                content.body = "Your food item, \(newFoodItem.wrappedName) is about to go bad in 2 days."
                                content.sound = UNNotificationSound.default
                                var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: twoDaysBefore)
                                dateComponents.hour = 10
                                dateComponents.minute = 0
                                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                print("dateComponents for notifs: \(dateComponents)")
                                let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
                                center.add(request)
                                Analytics.logEvent("addedFoodItem", parameters: nil)
                                do{
                                    try self.managedObjectContext.save()
                                } catch let error{
                                    print(error)
                                }
                                
                            })
                            ,.default(Text("Cancel"))
                        ])
                    })
                }
                if self.shoppingListItemTapped != nil {
                    Text("")
                    .actionSheet(item: self.$shoppingListItemTapped, content: { item in // << activated on item
                        ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this shopping list item"), buttons: [
                            .default(Text("Delete"), action: {
                                self.managedObjectContext.delete(item)
                                try?self.managedObjectContext.save()
                            })
                            ,.default(Text("Duplicate"), action: {
                                let newShoppingListItem = ShoppingList(context: self.managedObjectContext)
                                newShoppingListItem.icon = item.wrappedIcon
                                newShoppingListItem.name = item.wrappedName
                                Analytics.logEvent("addedShoppingItem", parameters: nil)
                                do{
                                    try self.managedObjectContext.save()
                                } catch let error{
                                    print(error)
                                }
                                
                            }),
                             .default(Text("Move to a storage location"), action: {
                                self.moveToStorageLocation = item
                             })
                            ,.default(Text("Cancel"))
                        ])
                    })
                }
                    
                                            
                
            }
        
            .navigationBarTitle("Hello, \(self.user.first?.name ?? "there")!")
                .onAppear(perform: {
                    if self.user.first == nil {
                        let newUser = User(context: self.managedObjectContext)
                        newUser.name = ""
                        if UserDefaults.standard.string(forKey: "name") != "" {
                            newUser.name = UserDefaults.standard.string(forKey: "name")
                        }
                        newUser.foodsEaten = Int32(0)
                        newUser.foodsThrownAway = Int32(0)
                        newUser.dailyGoal = Int16(0)
                        newUser.streak = Int16(0)
                        try? self.managedObjectContext.save()
                    }else if self.user.count == 1{
                        
                    }else {
                        Analytics.logEvent("multipleUsersInCoredata", parameters: ["users": self.user.count])
                        for indx in 0...self.user.count - 1{
                            if indx != 0 {
                                self.managedObjectContext.delete(self.user[indx])
                                try? self.managedObjectContext.save()
                            }
                        }
                    }
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                        } else if let error = error {
                            print(error)
                            
                        }
                    }
                    
                    
                    if RemoteConfigManager.boolValue(forkey: RCKeys.requestReview.rawValue) && self.user.first?.didReviewThisMonth == false{
                        rateApp()
                        
                        Analytics.logEvent("requestedReview", parameters: nil)
                    }
                })
        .navigationBarBackButtonHidden(true)
        
    }
}

struct FoodsToEatSoonView: View{
    @State var showEatActionSheet = false
    @Binding var showAddToShoppingListAlert: ShoppingListItem?
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    @Binding var foodItemTapped: FoodItem?
    @Binding var editFoodItem: FoodItem?
    @State var showMoreInfoOnFoodsToEatSoon = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>
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
    @State var geo: GeometryProxy
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    var body: some View{
            VStack{
                Group{
                    if self.foodItem.count >= 10{
                        Group{
                        VStack(alignment: .leading){
                            HStack{
                                Text("Foods To Eat Soon")
                                    .font(.custom("SFCompactDisplay", size: 23))
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                Spacer()
                                Button(action: {
                                    self.showMoreInfoOnFoodsToEatSoon.toggle()
                                }, label: {
                                    Image(systemName: self.showMoreInfoOnFoodsToEatSoon ? "questionmark.circle.fill":"questionmark.circle")
                                }).padding()
                            }.padding(.horizontal)
                            if self.showMoreInfoOnFoodsToEatSoon {
                                Text("Tap on any food or shopping list item to toggle more options.")
                                    .padding()
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal)
                                    .foregroundColor(Color(hex: "878787"))
                            }
                        }
                            
                        ForEach(0..<10) { index in
                            
                            RefrigeratorItemCell(icon: self.foodItem[index].wrappedSymbol, title: self.foodItem[index].wrappedName, lastsUntil: self.addDays(days: Int(self.foodItem[index].wrappedStaysFreshFor), dateCreated: self.foodItem[index].wrappedInStorageSince), storageLocationIcon: self.foodItem[index].origion?.symbolName ?? "", item: self.foodItem[index])
                                .onTapGesture {
                                    simpleSuccess()
                                    print("pressed long press")
                                    self.foodItemTapped = self.foodItem[index]
                                }
                            
                        }
                            
                        
                        NavigationLink(destination: SeeMoreView(), label: {Text("see more").foregroundColor(.blue).multilineTextAlignment(.leading)})
                        
                        }
//                        .sheet(item: self.$editFoodItem, content: { item in
//                            EditFoodItemPopUpView(foodItem: item, icon: item.wrappedSymbol, title: item.wrappedName, lastsFor: Int(item.wrappedStaysFreshFor))
//                        })
                    }else if self.foodItem.count <= 9 && self.foodItem.count > 0 {
                        Group{
                        VStack(alignment: .leading){
                            HStack{
                                Text("Foods To Eat Soon")
                                    .font(.custom("SFCompactDisplay", size: 23))
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                Spacer()
                                Button(action: {
                                    self.showMoreInfoOnFoodsToEatSoon.toggle()
                                }, label: {
                                    Image(systemName: self.showMoreInfoOnFoodsToEatSoon ? "questionmark.circle.fill":"questionmark.circle")
                                    }).padding()
                            }.padding(.horizontal)
                            if self.showMoreInfoOnFoodsToEatSoon {
                                Text("Tap on any food item or shopping list item to see more options")
                                    .padding()
                                    .padding(.horizontal)
                                    .foregroundColor(Color(hex: "878787"))
                            }
                        }
                        ForEach(self.foodItem, id: \.self) { index in
                            
                            RefrigeratorItemCell(icon: index.wrappedSymbol, title: index.wrappedName, lastsUntil: self.addDays(days: Int(index.wrappedStaysFreshFor), dateCreated: index.wrappedInStorageSince), storageLocationIcon: index.origion?.symbolName ?? "", item: index)
                                .onTapGesture {
                                    simpleSuccess()
                                    self.foodItemTapped = index
                            }
                                
                            
                            
                        }
                        
                        
                        
                        NavigationLink(destination: SeeMoreView(), label: {Text("see more").foregroundColor(.blue).multilineTextAlignment(.leading)})
                        
                        }
//                        .sheet(item: self.$editFoodItem, content: { item in
//                            EditFoodItemPopUpView(foodItem: item, icon: item.wrappedSymbol, title: item.wrappedName, lastsFor: Int(item.wrappedStaysFreshFor))
//                        })
                    }
                    else {
                        Text(RemoteConfigManager.stringValue(forkey: RCKeys.noFoodItemsText.rawValue))
                            .padding()
                    }
                    
                }
            }
            .alert(item: self.$showAddToShoppingListAlert, content: { item in
                    Alert(title: Text("Add \(item.name) to shopping list?"), message: Text("Click add to add \(item.name) to your shopping list."), primaryButton:
                        .default(Text("add"), action: {
                            let newShoppingItem = ShoppingList(context: self.managedObjectContext)
                            newShoppingItem.name = item.name
                            newShoppingItem.icon = item.icon
                            newShoppingItem.checked = false
                            do{
                                try self.managedObjectContext.save()
                            } catch let error{
                            print(error)
                            }
                            Analytics.logEvent("addedShoppingListItem", parameters: nil)
                        }), secondaryButton: .cancel(Text("Don't Add")))
                })
                
                .sheet(item: self.$editFoodItem, content: { item in
                                    EditFoodItemPopUpView(foodItem: item, icon: item.wrappedSymbol, title: item.wrappedName, lastsFor: Int(item.wrappedStaysFreshFor))
                                })
        
        
    }
}
struct HomeViewDashboardFeatures: View {
    @State var geo: GeometryProxy
    @State var funFactText = ""
    @Binding var showingView: String?
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var scan: VNDocumentCameraScan?
    @Binding var image: [CGImage]?
    @State var showAddFoodItemSheet = false
    @State var showAddStorageLocationSheet = false
    @FetchRequest(entity: StorageLocation.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>

    var body: some View{
        VStack{
            Divider()
                .foregroundColor(.black)
            
                if self.funFactText != "" {
                    Text("Here's a fun fact, \(self.funFactText)")
                        .font(.custom("SFProDisplayThin", size: 18))
                        .fontWeight(.thin)
                        .foregroundColor(Color(hex: "555555"))
                        .padding(.horizontal)
                    
                }
            //MARK: DAILY HABIT AND STREAK
            HStack{
                DailyGoalCell(geo: geo).padding()
                StreakCell(geo: geo).padding(.vertical).padding(.trailing)
            }.onAppear{
                let ref = Firestore.firestore().document("Others/funfoodFacts")
                ref.getDocument{(documentSnapshot, error) in
                    guard let docSnapshot = documentSnapshot, docSnapshot.exists else { self.funFactText = "did you know that brocoli contains more protein than steak?"
                        print("docSnapshot does not exist")
                        return}
                    
                    let myData = docSnapshot.data()
                    let arrayOfFoodFacts = myData?["data"] as? [String] ?? ["did you know that brocoli contains more protein than steak"]
                    self.funFactText = arrayOfFoodFacts.randomElement()!
                }
            }
            
               
            
            if self.storageLocation.count > 0{
                Group{
            Button(action: {
                self.showAddFoodItemSheet.toggle()
                print("storage locations: \(self.storageLocation.count)")
            }, label: {
                Image("AddFoodItemButton")
                    .renderingMode(.original)
                .padding()
                
            }).sheet(isPresented: self.$showAddFoodItemSheet, content: {
                AddAnyFoodItemsSheet(showingView: self.$showingView, scan: self.$scan, image: self.$image).environment(\.managedObjectContext, self.managedObjectContext).environmentObject(refrigerator)
            })
            }
            }else{
                Group{
            Button(action: {
                print("storage locations: \(self.storageLocation.count)")
                self.showAddStorageLocationSheet.toggle()
            }, label: {
                Image("AddStorageLocationButtonOrange")
                    .renderingMode(.original)
                .padding()
                })
                .sheet(isPresented: self.$showAddStorageLocationSheet, content: {
                AddToStorageItemSheet().environmentObject(refrigerator).environment(\.managedObjectContext, self.managedObjectContext)
                })
            }
            }
            
            
        }
        
    }
}
struct RemoteConfigManager {
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    private static var remoteConfig: RemoteConfig{
        let remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(refrigerator.defaultValues)
        return remoteConfig
    }
    static func configure() {
        remoteConfig.fetch() {(staus, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            print("Recieved Values From Remote Config")
                RemoteConfig.remoteConfig().activate(completionHandler: nil)
        }
    }
    
    static func stringValue(forkey key: String) -> String{
        return remoteConfig.configValue(forKey: key).stringValue!
    }
    static func intValue(forkey key: String) -> Int{
        return remoteConfig.configValue(forKey: key).numberValue as! Int
    }
    static func doubleValue(forkey key: String) -> Double{
        return remoteConfig.configValue(forKey: key).numberValue as! Double
    }
    
    
    static func boolValue(forkey key: String) -> Bool{
        return remoteConfig.configValue(forKey: key).boolValue
    }
    
}


struct GADBannerViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = AdUnitIDs.bannerProductionID.rawValue
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class MyDInterstitialDelegate: NSObject, GADInterstitialDelegate {
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.isReady{
            let root = UIApplication.shared.windows.first?.rootViewController
            ad.present(fromRootViewController: root!)
        } else {
            print("not ready")
        }
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        
    }
}



func rateApp() {
    if #available(iOS 10.3, *) {
        SKStoreReviewController.requestReview()
        
    } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "id1519358764") {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
func simpleSuccess() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

func addToDailyGoal(){
    guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    var user: [User]? = nil
    let managedContext =
        appDelegate.persistentContainer.viewContext
    let fetchRequest =
      NSFetchRequest<NSManagedObject>(entityName: "User")
    do {
      user = try managedContext.fetch(fetchRequest) as? [User]
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    let previousDG = user![0].dailyGoal
    user![0].dailyGoal = previousDG + 1
    if user![0].dailyGoal == 3{
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let tomorrow1 = DateComponents(year: now.year, month: now.month, day: now.day! + 1, hour: now.hour! + 6)
        let date1 = Calendar.current.date(from: tomorrow1)
        let midnight = Calendar.current.startOfDay(for: date1!)
        user![0].streakDueDate = midnight
        let prevStreak = user![0].streak
        user![0].streak = prevStreak + 1
    }
    do{
        try managedContext.save()
    }catch{
        print(error)
        Analytics.logEvent("errorSavingUserAddToDailyGoal", parameters: ["error": error.localizedDescription])
    }
}


    
