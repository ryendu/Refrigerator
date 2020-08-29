//
//  FoodItemCellFoodPlannerSelection.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/17/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct FoodItemCellFoodPlannerSelection: View {
    var icon: String
    var title: String
    var lastsUntil: Date
    var storageLocationIcon: String
    let calendar = Calendar.current
    @Binding var selection: FoodItem?
    var item: FoodItem
    @State var backgroundColor = "whiteAndGray"
    @State var daysLeft = Int()

    var body: some View {
            HStack {
                Text(self.icon)
                    .font(.largeTitle)
                    .padding(.leading, 8)
                VStack {
                    HStack {
                        Text(self.title)
                            .font(.custom("SFProDisplay", size: 16))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    HStack {
                        Text("lasts for \(self.daysLeft) days")
                            .font(.custom("SFCompactDisplay", size: 16))
                            .foregroundColor(Color(hex: "868686"))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                Spacer()
                
                Image(self.storageLocationIcon)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 22, alignment: .bottom)
                    .padding()
                    
            }.onAppear(perform: {
                let calendar = Calendar.current

                let date1 = calendar.startOfDay(for: Date())
                let date2 = calendar.startOfDay(for: self.lastsUntil)
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                self.daysLeft = components.day!
            })
            .padding()
            .background(Rectangle().cornerRadius(12)
                .foregroundColor(Color(self.backgroundColor))
            .shadow(color: Color("shadows"), radius: 3)
            )
            .padding(.horizontal)
                .padding(.leading)
        .onReceive(NotificationCenter.default.publisher(for: .shouldRefreshFoodPlannerSelection)) {_ in

            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.refreshSelection()
           }
        }
        
        
    }
    func refreshSelection () {
        if self.selection == self.item{
            self.backgroundColor = "orange"
            print("self is selection")
        }else {
            self.backgroundColor =  "whiteAndBlack"//TODO: Make a color
            print("self is not selection")
        }
    }
}

struct FoodItemCellFoodPlannerSelectionImage: View {
    var image: Data?
    var title: String
    var lastsUntil: Date
    var storageLocationIcon: String
    let calendar = Calendar.current
    @Binding var selection: FoodItem?
    let placeholderData: Data = UIImage(named: "plus")!.pngData()!
    var item: FoodItem
    @State var backgroundColor = "whiteAndGray"
    @State var daysLeft = Int()

    var body: some View {
            HStack {
                Image(uiImage: UIImage(data: image ?? placeholderData) ?? UIImage(named: "plus")!)
                    .resizable()
                    .frame(width:60,height:60,alignment: .leading)
                    .padding()
                VStack {
                    HStack {
                        Text(self.title)
                            .font(.custom("SFProDisplay", size: 16))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    HStack {
                        Text("lasts for \(self.daysLeft) days")
                            .font(.custom("SFCompactDisplay", size: 16))
                            .foregroundColor(Color(hex: "868686"))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                Spacer()
                
                Image(self.storageLocationIcon)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 22, alignment: .bottom)
                    .padding()
                    
            }.onAppear(perform: {
                let calendar = Calendar.current

                let date1 = calendar.startOfDay(for: Date())
                let date2 = calendar.startOfDay(for: self.lastsUntil)
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                self.daysLeft = components.day!
            })
            .padding()
            .background(Rectangle().cornerRadius(12)
                .foregroundColor(Color(self.backgroundColor))
            .shadow(color: Color("shadows"), radius: 3)
            )
            .padding(.horizontal)
                .padding(.leading)
        .onReceive(NotificationCenter.default.publisher(for: .shouldRefreshFoodPlannerSelection)) {_ in

            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.refreshSelection()
           }
        }
        
        
    }
    func refreshSelection () {
        if self.selection == self.item{
            self.backgroundColor = "orange"
            print("self is selection")
        }else {
            self.backgroundColor =  "whiteAndBlack"//TODO: Make a color
            print("self is not selection")
        }
    }
}

extension Notification.Name {

    static var shouldRefreshFoodPlannerSelection: Notification.Name {
        return Notification.Name("shouldRefreshFoodPlannerSelection")
    }
}
