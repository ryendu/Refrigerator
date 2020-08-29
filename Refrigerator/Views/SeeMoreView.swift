//
//  SeeMoreView.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/1/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleMobileAds

struct SeeMoreView: View {
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
        @State var interstitial: GADInterstitial!
    var adDelegate = MyDInterstitialDelegate()
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>

    @State var showAddToShoppingListAlert: ShoppingListItem? = nil
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var foodItemTapped: FoodItem? = nil
    @State var editFoodItem: FoodItem? = nil
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                ForEach(self.foodItem, id: \.self) { item in
                    RefrigeratorItemCell(icon: item.wrappedSymbol, title: item.wrappedName, lastsUntil: self.addDays(days: Int(item.wrappedStaysFreshFor), dateCreated: item.wrappedInStorageSince), storageLocationIcon: item.origion?.symbolName ?? "", item: item)
                        .onTapGesture{
                            simpleSuccess()
                            self.foodItemTapped = item
                    }
                    
                        
                }
                .sheet(item: self.$editFoodItem, content: { item in
                EditFoodItemPopUpView(foodItem: item, icon: item.wrappedSymbol, title: item.wrappedName, lastsFor: Int(item.wrappedStaysFreshFor))
                })
                    
                Spacer()
                if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 12 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)) && self.refrigeratorViewModel.isPremiumPurchased() == false{
                    GADBannerViewController()
                        .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                }else {
                }
            })
            
        }.alert(item: self.$showAddToShoppingListAlert, content: { item in
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
        .actionSheet(item: self.$foodItemTapped, content: { item in // << activated on item
            ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this food item"), buttons: [
                .default(Text("Eat All"), action: {
                    addToDailyGoal()
                                    refreshDailyGoalAndStreak()
                    self.user.first?.foodsEaten += Int32(1)
                    let center = UNUserNotificationCenter.current()
                    center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                    self.showAddToShoppingListAlert = ShoppingListItem(name: item.wrappedName, icon: item.wrappedSymbol)
                    self.managedObjectContext.delete(item)
                    try? self.managedObjectContext.save()
                })
                ,.default(Text("Throw Away"), action: {
                    
                    self.user.first?.foodsThrownAway += Int32(1)
                    let center = UNUserNotificationCenter.current()
                    center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                    self.managedObjectContext.delete(item)
                    try? self.managedObjectContext.save()
                })
                ,.default(Text("Eat Some"), action: {
                    addToDailyGoal()
                    refreshDailyGoalAndStreak()
                    print("ate some of \(item)")
                })
                ,.default(Text("Edit"), action: {
                    addToDailyGoal()
                                    refreshDailyGoalAndStreak()
                    self.editFoodItem = item
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
                    newFoodItem.id = id
                    item.origion?.addToFoodItem(newFoodItem)
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
    .navigationBarTitle("Eat These Foods Soon")
        .onAppear(perform: {
            if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 10 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfPopups.rawValue)) && UserDefaults.standard.bool(forKey: "SeeMoreViewLoadedAd") == false && self.refrigeratorViewModel.isPremiumPurchased() == false{
                self.interstitial = GADInterstitial(adUnitID: AdUnitIDs.interstitialTestID.rawValue)
                self.interstitial.delegate = self.adDelegate
                
                let req = GADRequest()
                self.interstitial.load(req)

                UserDefaults.standard.set(true, forKey: "SeeMoreViewLoadedAd")
                
            }else {

            }
            
            
        })
    }
}

struct SeeMoreView_Previews: PreviewProvider {
    static var previews: some View {
        SeeMoreView()
    }
}
