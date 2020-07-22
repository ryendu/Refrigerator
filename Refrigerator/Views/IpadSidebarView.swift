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
    var body: some View{
        NavigationView{
            ZStack{
                ScrollView{
                    VStack{
                        //List{
                        NavigationLink(destination: HomeViewiPad(showingView: self.$showingView, scan: self.$scan, image: self.$image), label: {
                            HStack{
                                Image("Home icon").foregroundColor(.orange).padding()
                                
                                Text("Home")
                                    .foregroundColor(.black)
                                    .padding()
                                Spacer()
                            }
                        }).tag(0)
                        NavigationLink(destination: RefrigeratorViewiPad(showingView: self.$showingView, scan: self.$scan, image: self.$image).environmentObject(refrigerator), label: {
                            HStack{
                                Image("Fridge icon").foregroundColor(.orange).padding()
                               
                                Text("Refrigerator")
                                    .foregroundColor(.black)
                                    .padding()
                                 Spacer()
                            }
                        }).tag(0)
                        
                        NavigationLink(destination: FoodPlannerViewiPad(trackDate: refrigerator.trackDate).environmentObject(refrigerator), label: {
                            HStack{
                                Image(systemName: "calendar").foregroundColor(.orange).font(.system(size: 26)).padding()
                                
                                Text("Food Planner")
                                    .foregroundColor(.black)
                                    .padding()
                                Spacer()
                            }
                        }).tag(0)
                        NavigationLink(destination: SettingsViewiPad(), label: {
                            HStack{
                                Image(systemName: "gear").foregroundColor(.orange).font(.system(size: 25)).padding()
                                
                                Text("Settings")
                                    .foregroundColor(.black)
                                    .padding()
                                Spacer()
                            }
                        }).tag(0)
                        
                        
                        //}.listStyle(PlainListStyle())
                    }.accentColor(.orange)
                        .navigationBarBackButtonHidden(true)
                        .font(.headline)
                        .navigationBarTitle(Text("Refrigerators"))
                    
                    if self.showingView == "scanner" {
                        makeScannerView()
                    }
                    Spacer()
                }
            }
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

//struct SideBar: View{
//
//}
