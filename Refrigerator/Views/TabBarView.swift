//
//  TabBarView.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/2/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import VisionKit
import Vision
import Combine
import UIKit

struct TabBarView: View {
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
    var body: some View {
        ZStack{
            Color.white
        TabView(selection: $selection){
            
            HomeView(showingView: self.$showingView, scan: self.$scan, image: self.$image)
                .tabItem {
                    selection == 0 ? Image("Home icon filled") : Image("Home icon")
                }
            .tag(0)
            RefrigeratorView(showingView: self.$showingView, scan: self.$scan, image: self.$image).environmentObject(refrigerator)
                .tabItem {
                    selection == 1 ? Image("Fridge icon fillied") : Image("Fridge icon")
            }
            .tag(1)
            FoodPlannerView(trackDate: refrigerator.trackDate).environmentObject(refrigerator)
                .tabItem {
                    Image(systemName: "calendar").font(.system(size: 26))
                }
            .tag(2)
            SettingsView()
                .tabItem {
                    Image(systemName: "gear").font(.system(size: 25))
            }.accentColor(.orange)
        .tag(3)
            
        
        }
        .accentColor(.orange)
        .navigationBarBackButtonHidden(true)
        .font(.headline)
            
            if self.showingView == "scanner" {
                makeScannerView()
            }
            
    }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
