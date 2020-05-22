//
//  RefrigeratorItemCell.swift
//  RefrigeratorDesigning(SWIFTUI)
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
    @State var date = Date()
    @State var daysLeft = Int()

    func daysBetween(start: Date, end: Date) -> Int {
        let day1 = calendar.component(.day, from: start)
        let day2 = calendar.component(.day, from: end)
        return day2 - day1
    }
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.largeTitle)
                .padding(.leading, 8)
            VStack {
                HStack {
                    Text(title)
                        .font(.custom("SF Pro Text", size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                HStack {
                    //TODO: fix this
                    Text("lasts for \(daysBetween(start: self.date, end: self.lastsUntil)) days")
                        .font(.custom("SF Compact Display", size: 16))
                        .foregroundColor(Color(hex: "868686"))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            Spacer()
            
            }
            
        .padding()
        .background(Image("Rectangle").resizable().padding(.horizontal))
        .padding(.bottom)
    
        
    }
}

struct RefrigeratorItemCell_Previews: PreviewProvider {
    static var previews: some View {
        RefrigeratorItemCell(icon: "🥨", title: "Creme Brule", lastsUntil: Date())
    }
}


public extension Date {
    func daysTo(_ date: Date) -> Int? {
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day  // This will return the number of day(s) between dates
    }
}
