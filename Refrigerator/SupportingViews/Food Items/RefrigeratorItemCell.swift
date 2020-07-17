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
    let calendar = Calendar.current
    @State var daysLeft = Int()

    
    var body: some View {
        HStack {
            Text(icon)
                .font(.largeTitle)
                .padding(.leading, 8)
            VStack {
                HStack {
                    Text(title)
                        .font(.custom("SFProDisplay", size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                HStack {
                    Text("lasts for \(daysLeft) days")
                        .font(.custom("SFCompactDisplay", size: 16))
                        .foregroundColor(Color(hex: "868686"))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            Spacer()
            
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

struct RefrigeratorItemCell_Previews: PreviewProvider {
    static var previews: some View {
        RefrigeratorItemCell(icon: "🥨", title: "Creme Brule", lastsUntil: Date())
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
