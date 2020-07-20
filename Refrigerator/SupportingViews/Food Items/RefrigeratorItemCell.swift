//
//  RefrigeratorItemCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/1/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct RefrigeratorItemCell: View {
    var icon: String
    var title: String
    var lastsUntil: Date
    var storageLocationIcon: String
    let calendar = Calendar.current
    @State var item: FoodItem
    @State var daysLeft = Int()

    
    var body: some View {
            HStack {
                if self.item.usesImage == false{
                Text(self.icon)
                    .font(.largeTitle)
                    .padding(.leading, 8)
                }else {
                    Image(uiImage: UIImage(data: self.item.image) ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .scaledToFit()
                        .frame(width: 55, height: 55, alignment: .leading)
                    .padding()
                }
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
            .foregroundColor(Color("whiteAndGray"))
            .shadow(color: Color("shadows"), radius: 3)
            )
            .padding(.horizontal)
        
    }
}

public extension Date {
    func daysTo(date: Date) -> Int {
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!  
    }
}
