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
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var foodItemTapped: FoodItem? = nil
    @State var editFoodItem: FoodItem? = nil
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                ForEach(self.foodItem, id: \.self) { item in
                    RefrigeratorItemCell(icon: item.wrappedSymbol, title: item.wrappedName, lastsUntil: self.addDays(days: Int(item.wrappedStaysFreshFor), dateCreated: item.wrappedInStorageSince))
                        .onTapGesture{}
                        .gesture(LongPressGesture()
                            .onEnded({ i in
                                self.foodItemTapped = item
                            })
                    )
                        //TODO: Make a diffrence between eat all and throw away
                        
                }
                .sheet(item: self.$editFoodItem, content: { item in
                EditFoodItemPopUpView(foodItem: item, icon: item.wrappedSymbol, title: item.wrappedName, lastsFor: Int(item.wrappedStaysFreshFor))
                })
                .actionSheet(item: self.$foodItemTapped, content: { item in // << activated on item
                    ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this food item"), buttons: [
                        .default(Text("Eat All"), action: {
                            var previousInteger = UserDefaults.standard.double(forKey: "eaten")
                            previousInteger += 1.0
                            UserDefaults.standard.set(previousInteger, forKey: "eaten")
                            self.managedObjectContext.delete(item)
                            try? self.managedObjectContext.save()
                        })
                        ,.default(Text("Throw Away"), action: {
                            var previousData = [shoppingListItems]()
                            if let data = UserDefaults.standard.data(forKey: "recentlyDeleted") {
                                do {
                                    let decoder = JSONDecoder()
                                    let note = try decoder.decode([shoppingListItems].self, from: data)
                                    previousData = note
                                } catch {
                                    print("Unable to Decode Note (\(error))")
                                }
                            }
                            previousData.append(shoppingListItems(icon: item.wrappedSymbol, title: item.wrappedName))
                            
                            do {
                                let encoder = JSONEncoder()
                                
                                let data = try encoder.encode(previousData)
                                
                                UserDefaults.standard.set(data, forKey: "recentlyDeleted")
                                
                            } catch {
                                print("Unable to Encode previousData (\(error))")
                            }
                            var previousInteger = UserDefaults.standard.double(forKey: "thrownAway")
                            previousInteger += 1.0
                            UserDefaults.standard.set(previousInteger, forKey: "thrownAway")
                            print(previousData)
                            print(UserDefaults.standard.data(forKey: "recentlyDeleted")!)
                            self.managedObjectContext.delete(item)
                            try? self.managedObjectContext.save()
                        })
                        ,.default(Text("Eat Some"), action: {
                            //TODO: Make this actrually do something
                            print("ate some of \(item)")
                        })
                        ,.default(Text("Edit"), action: {
                            //TODO: Make this actrually do something
                            self.editFoodItem = item
                        })
                        ,.default(Text("Duplicate"), action: {
                            let newFoodItem = FoodItem(context: self.managedObjectContext)
                            newFoodItem.staysFreshFor = item.staysFreshFor
                            newFoodItem.symbol = item.symbol
                            newFoodItem.name = item.name
                            newFoodItem.inStorageSince = Date()
                            newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                            newFoodItem.origion?.storageName = item.origion?.storageName
                            newFoodItem.origion?.symbolName = item.origion?.symbolName
                            newFoodItem.id = UUID()
                            Analytics.logEvent("addedFoodItem", parameters: ["nameOfFood" : item.name ?? ""])
                            do{
                                try self.managedObjectContext.save()
                            } catch let error{
                                print(error)
                            }
                            
                        })
                        ,.default(Text("Cancel"))
                    ])
                })
                Spacer()
            })
            
        }
    .navigationBarTitle("Eat These Foods Soon")
        .onAppear(perform: {
            if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 10 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfPopups.rawValue)) && UserDefaults.standard.bool(forKey: "SeeMoreViewLoadedAd") == false{
                //FIXME: Change the Adunit ID To My AdUNITID that i didnt set yet but will set when i create a new Interetitial ad in admob
                self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
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
