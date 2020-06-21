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
struct HomeView: View {
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    @State var ref: DocumentReference!
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
    
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @FetchRequest(entity: StorageLocation.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @FetchRequest(entity: ShoppingList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingList.name, ascending: true)]) var shoppingList: FetchedResults<ShoppingList>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @State var shadowAmount = 0
    @State var addToShoppingList = false
    @State var showEatActionSheet = false
    @State var foodItemTapped: FoodItem? = nil
    @State var shoppingListItemTapped: ShoppingList? = nil
    @State var editFoodItem: FoodItem? = nil
    @State var displayAmount = 0
    @State var moveToStorageLocation: ShoppingList? = nil
    @State var funFactText = ""
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                    ScrollView(.vertical, showsIndicators: true, content: {
                        VStack {
                            
                            VStack{
                                HStack{
                                    Text("Here's a fun fact")
                                        .font(.custom("SF Compact Display", size: 23))
                                        .padding()
                                    
                                    Spacer()
                                }
                                
                                FunFactCell(funFact: self.funFactText, geo: geo)
                            }.multilineTextAlignment(.center)
                            
                            if self.foodItem.count >= 10{
                                HStack{
                                    Text("Eat These Foods Soon")
                                        .font(.custom("SF Compact Display", size: 23))
                                    Spacer()
                                } .padding()
                                
                                Text("Long press on any food item or shopping list item to see more options")
                                    .padding()
                                    .foregroundColor(Color(hex: "878787"))
                                
                                ForEach(0..<10) { index in
                                    
                                    RefrigeratorItemCell(icon: self.foodItem[index].wrappedSymbol, title: self.foodItem[index].wrappedName, lastsUntil: self.addDays(days: Int(self.foodItem[index].wrappedStaysFreshFor), dateCreated: self.foodItem[index].wrappedInStorageSince))
                                        
                                        .onTapGesture {}
                                        .onLongPressGesture {
                                                print("pressed long press")
                                                self.foodItemTapped = self.foodItem[index]
                                        }
                                    
                                    
                                }.actionSheet(item: self.$foodItemTapped, content: { item in // << activated on item
                                    ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this food item"), buttons: [
                                        .default(Text("Eat All"), action: {
                                            var previousInteger = UserDefaults.standard.double(forKey: "eaten")
                                            previousInteger += 1.0
                                            UserDefaults.standard.set(previousInteger, forKey: "eaten")
                                            let center = UNUserNotificationCenter.current()
                                            center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
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
                                            
                                            
                                            let center = UNUserNotificationCenter.current()
                                            center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                                            self.managedObjectContext.delete(item)
                                            try? self.managedObjectContext.save()
                                        })
                                        ,.default(Text("Eat Some"), action: {
                                            print("ate some of \(item)")
                                        })
                                        ,.default(Text("Edit"), action: {
                                            self.editFoodItem = item
                                        })
                                        
                                        ,.default(Text("Duplicate"), action: {
                                            let id = UUID()
                                            let newFoodItem = FoodItem(context: self.managedObjectContext)
                                            newFoodItem.staysFreshFor = item.staysFreshFor
                                            newFoodItem.symbol = item.symbol
                                            newFoodItem.name = item.name
                                            newFoodItem.inStorageSince = Date()
                                            newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                                            newFoodItem.origion?.storageName = item.origion?.storageName
                                            newFoodItem.origion?.symbolName = item.origion?.symbolName
                                            newFoodItem.id = id
                                            
                                            let center = UNUserNotificationCenter.current()
                                            let content = UNMutableNotificationContent()
                                            content.title = "Eat This Food Soon"
                                            let date = Date()
                                            let twoDaysBefore = self.addDays(days: Int(item.staysFreshFor) - 2, dateCreated: date)
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
                                
                                NavigationLink(destination: SeeMoreView(), label: {Text("see more").foregroundColor(.blue).multilineTextAlignment(.leading)})
                            }else if self.foodItem.count <= 9 && self.foodItem.count > 0 {
                                HStack{
                                    Text("Eat These Foods Soon")
                                        .font(.custom("SF Compact Display", size: 23))
                                    Spacer()
                                } .padding()
                                Text("Long press on any food item or shopping list item to see more options")
                                    .padding()
                                    .foregroundColor(Color(hex: "878787"))
                                
                                ForEach(self.foodItem, id: \.self) { index in
                                    
                                    RefrigeratorItemCell(icon: index.wrappedSymbol, title: index.wrappedName, lastsUntil: self.addDays(days: Int(index.wrappedStaysFreshFor), dateCreated: index.wrappedInStorageSince))
                                        .onTapGesture {}
                                        .onLongPressGesture {
                                            self.foodItemTapped = index
                                    }
                                        
                                    
                                    
                                }.actionSheet(item: self.$foodItemTapped, content: { item in // << activated on item
                                    ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this food item"), buttons: [
                                        .default(Text("Eat All"), action: {
                                            var previousInteger = UserDefaults.standard.double(forKey: "eaten")
                                            previousInteger += 1.0
                                            UserDefaults.standard.set(previousInteger, forKey: "eaten")
                                            let center = UNUserNotificationCenter.current()
                                            center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
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
                                            
                                            
                                            let center = UNUserNotificationCenter.current()
                                            center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                                            self.managedObjectContext.delete(item)
                                            try? self.managedObjectContext.save()
                                        })
                                        ,.default(Text("Eat Some"), action: {
                                            print("ate some of \(item)")
                                        })
                                        ,.default(Text("Edit"), action: {
                                            self.editFoodItem = item
                                        })
                                        
                                        ,.default(Text("Duplicate"), action: {
                                            let id = UUID()
                                            let newFoodItem = FoodItem(context: self.managedObjectContext)
                                            newFoodItem.staysFreshFor = item.staysFreshFor
                                            newFoodItem.symbol = item.symbol
                                            newFoodItem.name = item.name
                                            newFoodItem.inStorageSince = Date()
                                            newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                                            newFoodItem.origion?.storageName = item.origion?.storageName
                                            newFoodItem.origion?.symbolName = item.origion?.symbolName
                                            newFoodItem.id = id
                                            
                                            let center = UNUserNotificationCenter.current()
                                            let content = UNMutableNotificationContent()
                                            content.title = "Eat This Food Soon"
                                            let date = Date()
                                            let twoDaysBefore = self.addDays(days: Int(item.staysFreshFor) - 2, dateCreated: date)
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
                                
                                
                                NavigationLink(destination: SeeMoreView(), label: {Text("see more").foregroundColor(.blue).multilineTextAlignment(.leading)})
                            }
                            else {
                                Text(RemoteConfigManager.stringValue(forkey: RCKeys.noFoodItemsText.rawValue))
                                    .padding()
                            }
                            
                            
                            if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsInHomeView.rawValue) >= 2 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)){
                                GADBannerViewController()
                                    .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                            }else {
                                
                            }
                            HStack{
                                Text("Shopping List")
                                    .font(.custom("SF Compact Display", size: 23))
                                Spacer()
                                Button(action: {
                                    print("pressed add to shopping list button")
                                    
                                    self.refrigeratorViewModel.isInShoppingListItemAddingView.toggle()
                                }, label: {Image("plus")})
                                
                            } .padding()
                            
                            Text(RemoteConfigManager.stringValue(forkey: RCKeys.shoppingListDescriptionHomeView.rawValue))
                                .padding()
                                .foregroundColor(Color(hex: "878787"))
                            
                            ForEach(self.shoppingList, id: \.self) { item in
                                
                                
                                ShoppingListCell(icon: item.wrappedIcon, title: item.wrappedName, shoppingItem: item)
                                    .onTapGesture {}
                                    .onLongPressGesture {
                                        simpleSuccess()
                                        self.shoppingListItemTapped = item
                                }
                                    
                                
                            }.actionSheet(item: self.$shoppingListItemTapped, content: { item in // << activated on item
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
                            
                            
                            if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsInHomeView.rawValue) >= 1 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)){
                                GADBannerViewController()
                                    .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                            }else {
                            }
                        }
                        
                        
                        
                        .sheet(item: self.$moveToStorageLocation, content: { _ in
                                MoveShoppingItemToStorageSheet(Item: self.$moveToStorageLocation).environment(\.managedObjectContext, self.managedObjectContext)
                            })
                    })
                    
                    
                    
                /*}.padding()*/
                        
                
            }.navigationBarTitle("Hi, \(UserDefaults.standard.string(forKey: "name") ?? "name not set (go to settings)")")
                .sheet(item: self.$editFoodItem, content: { item in
                    EditFoodItemPopUpView(foodItem: item, icon: item.wrappedSymbol, title: item.wrappedName, lastsFor: Int(item.wrappedStaysFreshFor))
                })
                
                .onAppear(perform: {
                    
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                        } else if let error = error {
                            print(error)
                            
                        }
                    }
                    
                    self.ref = Firestore.firestore().document("Others/funfoodFacts")
                    self.ref.getDocument{(documentSnapshot, error) in
                        guard let docSnapshot = documentSnapshot, docSnapshot.exists else { self.funFactText = "did you know that brocoli contains more protein than steak?"
                            print("docSnapshot does not exist")
                            return}
                        
                        let myData = docSnapshot.data()
                        let arrayOfFoodFacts = myData?["data"] as? [String] ?? ["did you know that brocoli contains more protein than steak"]
                        self.funFactText = arrayOfFoodFacts.randomElement()!
                    }
                    if RemoteConfigManager.boolValue(forkey: RCKeys.requestReview.rawValue) && UserDefaults.standard.bool(forKey: "didReviewThisMonth") == false{
                        rateApp()
                        
                        Analytics.logEvent("requestedReview", parameters: nil)
                    }
                })
        }
            
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $refrigeratorViewModel.isInShoppingListItemAddingView, content: {AddToShoppingListSheet().environmentObject(refrigerator).environment(\.managedObjectContext, self.managedObjectContext) })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(refrigerator)
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
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
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
