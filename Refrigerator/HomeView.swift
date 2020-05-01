//
//  HomeView.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/28/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var funFoodFacts = ["did you know brocoli contains more protein than steak", "Chocolate is as healthy as a fruit"]
    var body: some View {
        VStack {
            Text("Hi, \(UserDefaults.standard.string(forKey: "name")!)")
            //TODO: get a list of fun food facts from the web and put below
            Text(funFoodFacts[Int.random(in: 0...(funFoodFacts.count - 1))])
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
