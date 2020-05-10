//
//  TabBarView.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/2/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            //TODO: make the tab items when not displayed not filled and when displayed filled
            
            HomeView()
                .tabItem {
                    Image("Home icon filled")
                }
            RefrigeratorView().environmentObject(refrigerator)
                .tabItem {
                    Image("Fridge icon fillied")
                }
            ProgressView()
                .tabItem {
                    Image("Progress icon filled")
                }
        }
        .font(.headline)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
