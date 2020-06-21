//
//  RefrigeratorView.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/2/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData
import GoogleMobileAds
import Firebase
import Vision
import VisionKit

enum storageLocationIcons: String {
    case fridgeGreen = "Fridge pastel icon green"
    case fridgeOrange = "Fridge pastel icon orange"
    case fridgeRed = "Fridge pastel icon red"
    case fridgePurple = "Fridge pastel icon purple"
    case fridgeYellow = "Fridge pastel icon yellow"
    case fridgeTurquoise = "Fridge pastel icon turquoise"
    case pantryGreen = "pantry green"
    case pantryOrange = "pantry orange"
    case pantryRed = "pantry red"
    case pantryPurple = "pantry purple"
    case pantryYellow = "pantry yellow"
    case pantryTurquoice = "pantry turquoise"
}

struct RefrigeratorView: View {
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
    @Binding var showingView: String?
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isShowingActionSheet = false
    @State var indexOfDelete = 0
    @Binding var scan: VNDocumentCameraScan?
    @Binding var image: [CGImage]?
    var body: some View {
        NavigationView {
                
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    
                    
                    if storageLocation.count > 0{
                    ForEach(self.storageLocation, id: \.self) { item in
                                                
                        NavigationLink(destination: IndivisualRefrigeratorView(storageIndex: item, showingView: self.$showingView, scan: self.$scan, image: self.$image ).environment(\.managedObjectContext, self.managedObjectContext)) {
                            StorageLocationCell(storageLocationIcon: item.wrappedSymbolName, storageLocationNumberOfItems: item.foodItemArray.count, storageLocationTitle: item.wrappedStorageName, storage: item).environment(\.managedObjectContext, self.managedObjectContext)
                            }.buttonStyle(PlainButtonStyle())


                    }
                    } else {
                        Text("Start by adding a new Storage location with the plus button above")
                    }
                    
                    if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 7 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)){
                    GADBannerViewController()
                    .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                    }else {

                    }
                }
                    .navigationBarTitle("Refrigerator View")
                    .navigationBarItems(trailing:
                    Button(action: {
                        
                        self.refrigeratorViewModel.isInStorageItemAddingView.toggle()
                    }, label: {
                        Image("plus")
                            .renderingMode(.original)
                    }))
                    
                .onAppear(perform: {
                    if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 11 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfPopups.rawValue)) && UserDefaults.standard.bool(forKey: "RefrigeratorViewLoadedAd") == false{
                        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-2772723693967190/6970289452")
                        self.interstitial.delegate = self.adDelegate
                        
                        let req = GADRequest()
                        self.interstitial.load(req)

                        UserDefaults.standard.set(true, forKey: "RefrigeratorViewLoadedAd")
                        
                    }else {

                    }
                    
                    
                })

            })
            
            }.navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $refrigeratorViewModel.isInStorageItemAddingView, content: {
                AddToStorageItemSheet().environmentObject(refrigerator).environment(\.managedObjectContext, self.managedObjectContext)
            })
        

        
    }
}
