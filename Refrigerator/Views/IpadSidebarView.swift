//
//  IpadSidebarView.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/21/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import VisionKit
import Vision

struct IpadSidebarView: View {
    @State var scan: VNDocumentCameraScan? = nil
    @State var image: [CGImage]? = nil
    @State var foodItemTapped: FoodItem? = nil
    @State private var selection = 0
    @State var showingView: String? = "fridge"
    private func makeScannerView() -> ScanningView {
        ScanningView(completion: { (images, scan) in
            if images == nil && scan == nil {
                self.showingView = "fridge"
            } else {
                self.showingView = "results"
                self.scan = scan
                self.image = images
                
            }
        })
    }
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    var body: some View{
        ZStack{
            NavigationView{
            ZStack{
                ScrollView{
                    VStack{
                        NavigationLink(destination: HomeViewiPad(showingView: self.$showingView, scan: self.$scan, image: self.$image), label: {
                            HStack{
                                Image(systemName: "house").foregroundColor(.orange).font(.system(size: 25)).padding(.vertical).padding(.leading)
                                Text("Home")
                                    .foregroundColor(Color("blackAndWhite"))
                                    .padding()
                                Spacer()
                            }
                        }).tag(0)
                        NavigationLink(destination: RefrigeratorViewiPad(showingView: self.$showingView, scan: self.$scan, image: self.$image).environmentObject(refrigerator), label: {
                            HStack{
                                Image(systemName: "square.grid.2x2").foregroundColor(.orange).font(.system(size: 25)).padding(.vertical).padding(.leading)
                                Text("Refrigerators")
                                    .foregroundColor(Color("blackAndWhite"))
                                    .padding()
                                 Spacer()
                            }
                        }).tag(0)
                        NavigationLink(destination: FoodPlannerViewiPad(trackDate: refrigerator.trackDate).environmentObject(refrigerator), label: {
                            HStack{
                                Image(systemName: "calendar").foregroundColor(.orange).font(.system(size: 26)).padding(.vertical).padding(.leading)
                                
                                Text("Food Planner")
                                    .foregroundColor(Color("blackAndWhite"))
                                    .padding()
                                Spacer()
                            }
                        }).tag(0)
                        NavigationLink(destination: SettingsViewiPad(), label: {
                            HStack{
                                Image(systemName: "gear").foregroundColor(.orange).font(.system(size: 25)).padding(.vertical).padding(.leading)
                                
                                Text("Settings")
                                    .foregroundColor(Color("blackAndWhite"))
                                    .padding()
                                Spacer()
                            }
                        }).tag(0)
                        
                        Divider().padding()
                        
                        if storageLocation.count > 0{
                        ForEach(self.storageLocation, id: \.self) { item in
                                                    
                            NavigationLink(destination: IndivisualRefrigeratorView(storageIndex: item, showingView: self.$showingView, scan: self.$scan, image: self.$image ).environment(\.managedObjectContext, self.managedObjectContext)) {
                                StorageLocationCell(storageLocationIcon: item.wrappedSymbolName, storageLocationNumberOfItems: item.foodItemArray.count, storageLocationTitle: item.wrappedStorageName, storage: item).environment(\.managedObjectContext, self.managedObjectContext)
                                }.buttonStyle(PlainButtonStyle())


                        }.padding(.leading)
                        }
                    }.accentColor(.orange)
                        .navigationBarBackButtonHidden(true)
                        .font(.headline)
                        .navigationBarTitle(Text("Refrigerators"))
                    
                    
                    Spacer()
                }
                
            }
        }.navigationViewStyle(DoubleColumnNavigationViewStyle()).accentColor(.orange)
            if self.showingView == "scanner" {
                makeScannerView()
            }
        }
    }
}

//struct SideBar: View{
//
//}
