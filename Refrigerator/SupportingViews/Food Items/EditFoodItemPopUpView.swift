//
//  EditFoodItemPopUpView.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/27/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData

struct EditFoodItemPopUpView: View {

    @State var foodItem: FoodItem
    @State var icon: String
    @State var title: String
    @State var lastsFor: Int
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Spacer()
                    HStack{
                        TextField(icon, text: $icon)
                    .frame(width: 40, height: 40)
                    .multilineTextAlignment(.center)
                        .font(.largeTitle)
                TextField(title, text: $title)
                    .font(.title)
                        
                    }.padding(.bottom)
                
                    
                        
                    
                       
                    
                    Stepper(value: $lastsFor, in: 1...1000) {
                        Text("lasts for \((lastsFor)) days")
                        .font(.custom("SFCompactDisplay", size: 16))
                        .foregroundColor(Color(hex: "868686"))
                            .multilineTextAlignment(.leading)
                            .frame(minWidth: 80)
                    }
            Spacer()
            Button(action: {
                self.foodItem.name = self.title
                self.foodItem.symbol = self.icon
                self.foodItem.staysFreshFor = Int16(self.lastsFor)
                addToDailyGoal()
                refreshDailyGoalAndStreak()
                let center = UNUserNotificationCenter.current()
                           center.removePendingNotificationRequests(withIdentifiers: [self.foodItem.wrappedID.uuidString])
                           
                           let content = UNMutableNotificationContent()
                           content.title = "Eat This Food Soon"
                           let date = Date()
                           let twoDaysBefore = addDays(days: self.lastsFor - 2, dateCreated: date)
                           content.body = "Your food item, \(self.foodItem.wrappedName) is about to go bad in 2 days."
                           content.sound = UNNotificationSound.default
                           var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: twoDaysBefore)
                           dateComponents.hour = 10
                           dateComponents.minute = 0
                           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                           let request = UNNotificationRequest(identifier: self.foodItem.wrappedID.uuidString, content: content, trigger: trigger)
                           center.add(request)
                try? self.managedObjectContext.save()
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("Update")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 200.0, height: 45.5)
                    
                
            })
            
            }.padding(20)
            .frame(width: 350, height: 450)
        
        
    }
}


