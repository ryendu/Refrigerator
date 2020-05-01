//
//  HomeView.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/28/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    
    var body: some View {
        VStack {
            Text("Hi, \(UserDefaults.standard.string(forKey: "name")!)")
//            Text(restrauntViewModel.randomFact[Int.random(in: 0...restrauntViewModel.randomFact.count)])
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
