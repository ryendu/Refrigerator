//
//  TabBarView.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/2/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection){
            //TODO: make the tab items when not displayed not filled and when displayed filled
            
            HomeView()
                .tabItem {
                    selection == 0 ? Image("Home icon filled") : Image("Home icon")
                }
            .tag(0)
            RefrigeratorView().environmentObject(refrigerator)
                .tabItem {
                    selection == 1 ? Image("Fridge icon fillied") : Image("Fridge icon")
            }
            .tag(1)
            SettingsView()
                .tabItem {
                    selection == 2 ?  Image("Settings icon filled") : Image("Settings icon")
            }
        .tag(2)
        
        }
        .navigationBarBackButtonHidden(true)
        .font(.headline)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
