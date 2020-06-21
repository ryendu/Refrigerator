//
//  MoveShoppingItemToStorageSheet.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/27/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleMobileAds
import UserNotifications

struct MoveShoppingItemToStorageSheet: View {
    @Environment(\.presentationMode) var presentationMode

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
    @Binding var Item: ShoppingList?
        @State var interstitial: GADInterstitial!
    var adDelegate = MyDInterstitialDelegate()

    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext
    var body: some View {
        ZStack{
            
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack {
                HStack {
                    
                    Text("Pick A Storage Location To Move Your Shopping List Item To.")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                }.padding()
                
                if storageLocation.count >= 1{
                ForEach(self.storageLocation, id: \.self) { item in
                                            
                    Button(action: {
                        let id = UUID()
                        let newFoodItem = FoodItem(context: self.managedObjectContext)
                        newFoodItem.staysFreshFor = 7
                        newFoodItem.symbol = self.Item?.wrappedIcon
                        newFoodItem.name = self.Item?.wrappedName
                        newFoodItem.inStorageSince = Date()
                        newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                        newFoodItem.origion?.storageName = item.wrappedStorageName
                        newFoodItem.origion?.symbolName = item.wrappedSymbolName
                        newFoodItem.id = id
                        Analytics.logEvent("addedFoodItem", parameters: nil)
                        do{
                            try self.managedObjectContext.save()
                        } catch let error{
                            print(error)
                        }
                        self.managedObjectContext.delete(self.Item!)
                        try?self.managedObjectContext.save()
                        
                        let center = UNUserNotificationCenter.current()
                        let content = UNMutableNotificationContent()
                        content.title = "Eat This Food Soon"
                        let date = Date()
                        let twoDaysBefore = addDays(days: 7 - 2, dateCreated: date)
                        content.body = "Your food item, \(newFoodItem.wrappedName) is about to go bad in 2 days."
                        content.sound = UNNotificationSound.default
                        var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: twoDaysBefore)
                        dateComponents.hour = 10
                        dateComponents.minute = 0
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
                        center.add(request)
                        
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        
                            StorageLocationCell(storageLocationIcon: item.wrappedSymbolName, storageLocationNumberOfItems: item.foodItemArray.count, storageLocationTitle: item.wrappedStorageName, storage: item).environment(\.managedObjectContext, self.managedObjectContext)
                        
                    }).buttonStyle(PlainButtonStyle())


                }
                } else {
                    Text("There are no storage Locations")
                }
                
                if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 5 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)){
                GADBannerViewController()
                .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                    .padding(.top, 150)
                }else {

                }
            }

        })
        }
    }
}


