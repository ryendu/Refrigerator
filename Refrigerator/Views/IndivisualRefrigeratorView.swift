//
//  IndivisualRefrigeratorView.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/5/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData
import VisionKit
import Vision
import Combine
import UIKit
import Firebase



struct IndivisualRefrigeratorView: View {
    var storageIndex: StorageLocation
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showEatActionSheet = false
    @Binding var showingView: String?
    @Binding var scan: VNDocumentCameraScan?
    @Binding var image: [CGImage]?
    @State var foodItemTapped: FoodItem? = nil

    @State var interstitial: GADInterstitial!
    var adDelegate = MyDInterstitialDelegate()
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
    @State var editFoodItem = false

    var body: some View {
        ZStack {
            
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    
                    
                    
                    
                    if editFoodItem == false {
                        Text("Long hold for more options").padding()
                        .font(.custom("SF Compact Display", size: 16))
                        .foregroundColor(.gray)
                    
                    ForEach(self.storageIndex.foodItemArray, id: \.self) { item in
                       RefrigeratorItemCell(icon: item.wrappedSymbol, title: item.wrappedName, lastsUntil: self.addDays(days: Int(item.wrappedStaysFreshFor), dateCreated: item.wrappedInStorageSince))
                        .onTapGesture {}
                        .gesture(LongPressGesture()
                            .onEnded({ i in
                                simpleSuccess()
                                self.foodItemTapped = item      // << tapped item
                            }))
                    }
                        .actionSheet(item: self.$foodItemTapped, content: { item in // << activated on item
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
                        
                    } else {
                        ForEach(self.storageIndex.foodItemArray, id: \.self) { item in
                            DetectItemCoreDataCell(foodsToDisplay: item)
                        }
                    }
                    if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 8 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)){
                    GADBannerViewController()
                    .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                    }else {

                    }
                    NavigationLink(destination: ExamineRecieptView(image: self.$image, showingView: self.$showingView, storageIndex: self.storageIndex, scan: self.$scan), tag: "results", selection: self.$showingView, label: {Text("")})
                }
                .navigationBarItems(trailing: HStack{
                    if self.editFoodItem == false{
                    Button(action: {
                self.editFoodItem.toggle()
                
            }, label: {
                Text("Edit").layoutPriority(1)
                    
                        }).padding(6)
                        
                    }else{
                        Button(action: {
                            self.editFoodItem.toggle()
                            
                        }, label: {
                            Text("Done").layoutPriority(1)
                                
                                    }).padding(6)
                    }
                    Button(action: {
                                   self.showingView = "scanner"
                                   
                               }, label: {
                                   Image("scanIcon")
                                       .resizable()
                                       .renderingMode(.original)
                                       .aspectRatio(contentMode: .fit)
                                       .frame(width: 30, height: 30)
                                       
                               }).padding(6)
                    Button(action: {
                        self.refrigeratorViewModel.isInAddFridgeItemView.toggle()
                    }, label: {
                        Image("plus")
                            .renderingMode(.original)
                            
                        }).padding(6)
                    
                    
                    
                })

            .navigationBarTitle(storageIndex.wrappedStorageName)
            .onAppear(perform: {
                if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 9 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfPopups.rawValue)) && UserDefaults.standard.bool(forKey: "IndivisualRefrigeratorViewLoadedAd") == false{
                    self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
                    self.interstitial.delegate = self.adDelegate
                    
                    let req = GADRequest()
                    self.interstitial.load(req)

                    UserDefaults.standard.set(true, forKey: "IndivisualRefrigeratorViewLoadedAd")
                    
                }else {

                }
                
                
            })
                    
                    
                .sheet(isPresented: $refrigeratorViewModel.isInAddFridgeItemView, content: {
                    AddFoodItemSheet(storage: self.storageIndex).environmentObject(refrigerator).environment(\.managedObjectContext, self.managedObjectContext)
                })
                
                
                
                
                
            })
            

        }
        
        
    }

}


struct ScanningView: UIViewControllerRepresentable {
    
    private let completionHandler: ([CGImage]?, VNDocumentCameraScan?) -> Void
    
    init(completion: @escaping ([CGImage]?, VNDocumentCameraScan?) -> Void) {
        self.completionHandler = completion
    }
    
    
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScanningView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScanningView>) {
        
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        private var images = [CGImage]()
        private let completionHandler: ([CGImage]?, VNDocumentCameraScan?) -> Void
        
        init(completion: @escaping ([CGImage]?, VNDocumentCameraScan?) -> Void) {
            
            self.completionHandler = completion
        }
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil, nil)
            
        }
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            completionHandler(nil, nil)
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    self.images.append(cgImage)
                }
            }
            
            completionHandler(images, scan)
            
        }
        
    }
    
}

