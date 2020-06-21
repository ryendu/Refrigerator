//
//  DetectItemCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/21/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct DetectItemCell: View {
    @Binding var foodsToDisplay: [refrigeItem]
    var index: Int
    @State var icon: String
    @State var title: String
    @State var lastsFor: Int
    
    
    var body: some View {
        HStack{
            TextField(icon, text: $icon)
            .frame(width: 40, height: 40)
            .multilineTextAlignment(.center)
            .font(.custom("SF Pro Text", size: 50))
        VStack{
            HStack{
                
                TextField(title, text: $title)
                            .font(.custom("SF Pro Text", size: 20))
                            .multilineTextAlignment(.leading)
            }
        HStack {
            
                
            
               
            
            Stepper(value: $lastsFor, in: 1...1000) {
                Text("lasts for \((lastsFor)) days")
                .font(.custom("SF Compact Display", size: 16))
                .foregroundColor(Color(hex: "868686"))
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 80)
            }
            Button(action: {
                self.foodsToDisplay.remove(at: self.index)
            }, label: {
                Image(systemName: "minus.circle")
                    .renderingMode(.original)
                    .padding()
            })
        
            }
        
    
        
            }
            
        }.padding()
    .background(Rectangle().cornerRadius(16).padding(.horizontal)
    .foregroundColor(Color("cellColor"))
    )
    .padding(.bottom)
}
}
struct DetectItemCoreDataCell: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var foodsToDisplay: FoodItem
    @State var icon = ""
    @State var title = ""
    @State var lastsFor = 7
    var body: some View {
        HStack{
            TextField(icon, text: $icon)
            .frame(width: 40, height: 40)
            .multilineTextAlignment(.center)
            .font(.custom("SF Pro Text", size: 50))
        VStack{
            HStack{
                
                TextField(title, text: $title)
                            .font(.custom("SF Pro Text", size: 20))
                            .multilineTextAlignment(.leading)
            }
        HStack {
            
                
            
               
            
            Stepper(value: $lastsFor, in: 1...1000) {
                Text("lasts for \((lastsFor)) days")
                .font(.custom("SF Compact Display", size: 16))
                .foregroundColor(Color(hex: "868686"))
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 80)
            }
            Button(action: {
                
                self.managedObjectContext.delete(self.foodsToDisplay)
                try? self.managedObjectContext.save()
                
            }, label: {
                Image(systemName: "minus.circle")
                    .renderingMode(.original)
                    .padding()
            })
        
            }
        
    
        
            }.onAppear(perform: {
                self.icon = self.foodsToDisplay.wrappedSymbol
                self.title = self.foodsToDisplay.wrappedName
                self.lastsFor = Int(self.foodsToDisplay.wrappedStaysFreshFor)
            })
        .onDisappear(perform: {
                self.foodsToDisplay.name = self.title
                self.foodsToDisplay.symbol = self.icon
                self.foodsToDisplay.staysFreshFor = Int16(self.lastsFor)
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [self.foodsToDisplay.wrappedID.uuidString])
            
            let content = UNMutableNotificationContent()
            content.title = "Eat This Food Soon"
            let date = Date()
            let twoDaysBefore = addDays(days: self.lastsFor - 2, dateCreated: date)
            content.body = "Your food item, \(self.foodsToDisplay.wrappedName) is about to go bad in 2 days."
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: twoDaysBefore)
            dateComponents.hour = 10
            dateComponents.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            print("dateComponents for notifs: \(dateComponents)")
            let request = UNNotificationRequest(identifier: self.foodsToDisplay.wrappedID.uuidString, content: content, trigger: trigger)
            center.add(request)
                try?self.managedObjectContext.save()
            })
            
        }.padding()
    .background(Rectangle().cornerRadius(16).padding(.horizontal)
    .foregroundColor(Color("cellColor"))
    )
    .padding(.bottom)
}
}
        
