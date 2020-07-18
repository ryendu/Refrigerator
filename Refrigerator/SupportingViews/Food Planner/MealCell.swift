//
//  MealCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/17/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import Firebase

struct MealCell: View {
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var meal: FoodPlannerMeal
    @State var editFoodItem: FoodItem? = nil
    @State var foodItemTapped: FoodItem? = nil
    @State var showAddFoodItemSheet = false
    @State var customMealTapped: MealItem? = nil
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text(meal.mealTitle ?? "")
                    .font(.custom("SFProDisplay-Bold", size: 27))
                    .foregroundColor(Color("lightGray"))
                    .padding()
                    .multilineTextAlignment(.leading)
            }
            
            //MARK: FOODS
            ForEach(self.meal.mealItemsArray, id: \.self){index in
                CustomMealCell(icon: index.icon ?? "", title: index.name ?? "")
                    .onTapGesture {
                        self.customMealTapped = index
                }
            }
            ForEach(self.meal.foodItemsArray, id: \.self){ index in
                
                RefrigeratorItemCell(icon: index.wrappedSymbol, title: index.wrappedName, lastsUntil: self.addDays(days: Int(index.wrappedStaysFreshFor), dateCreated: index.wrappedInStorageSince), storageLocationIcon: index.origion?.symbolName ?? "")
                    .onTapGesture {
                        self.foodItemTapped = index
                }
                
                
            }.actionSheet(item: self.$foodItemTapped, content: { item in // << activated on item
                ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this food item"), buttons: [
                    .default(Text("Eat All"), action: {
                        addToDailyGoal()
                        refreshDailyGoalAndStreak()
                        var previousInteger = UserDefaults.standard.double(forKey: "eaten")
                        previousInteger += 1.0
                        UserDefaults.standard.set(previousInteger, forKey: "eaten")
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                        self.managedObjectContext.delete(item)
                        try? self.managedObjectContext.save()
                    })
                    ,.default(Text("Throw Away"), action: {
                        var previousData = [shoppingListItems]()
                        if let data = UserDefaults.standard.data(forKey: "recentlyDeleted") {
                            do {
                                let decoder = JSONDecoder()
                                let note = try decoder.decode([shoppingListItems].self, from: data)
                                previousData = note
                            } catch {
                                print("Unable to Decode Note (\(error))")
                            }
                        }
                        previousData.append(shoppingListItems(icon: item.wrappedSymbol, title: item.wrappedName))
                        
                        do {
                            let encoder = JSONEncoder()
                            
                            let data = try encoder.encode(previousData)
                            
                            UserDefaults.standard.set(data, forKey: "recentlyDeleted")
                            
                        } catch {
                            print("Unable to Encode previousData (\(error))")
                        }
                        var previousInteger = UserDefaults.standard.double(forKey: "thrownAway")
                        previousInteger += 1.0
                        UserDefaults.standard.set(previousInteger, forKey: "thrownAway")
                        print(previousData)
                        print(UserDefaults.standard.data(forKey: "recentlyDeleted")!)
                        
                        
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                        self.managedObjectContext.delete(item)
                        try? self.managedObjectContext.save()
                    })
                    ,.default(Text("Eat Some"), action: {
                        addToDailyGoal()
                        refreshDailyGoalAndStreak()
                        print("ate some of \(item)")
                    })
                    ,.default(Text("Edit"), action: {
                        addToDailyGoal()
                        refreshDailyGoalAndStreak()
                        self.editFoodItem = item
                    })
                    
                    ,.default(Text("Duplicate"), action: {
                        let id = UUID()
                        let newFoodItem = FoodItem(context: self.managedObjectContext)
                        newFoodItem.staysFreshFor = item.staysFreshFor
                        newFoodItem.symbol = item.symbol
                        newFoodItem.name = item.name
                        newFoodItem.inStorageSince = Date()
                        newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                        newFoodItem.origion?.storageName = item.origion?.storageName
                        newFoodItem.origion?.symbolName = item.origion?.symbolName
                        newFoodItem.id = id
                        addToDailyGoal()
                        refreshDailyGoalAndStreak()
                        let center = UNUserNotificationCenter.current()
                        let content = UNMutableNotificationContent()
                        content.title = "Eat This Food Soon"
                        let date = Date()
                        let twoDaysBefore = self.addDays(days: Int(item.staysFreshFor) - 2, dateCreated: date)
                        content.body = "Your food item, \(newFoodItem.wrappedName) is about to go bad in 2 days."
                        content.sound = UNNotificationSound.default
                        var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: twoDaysBefore)
                        dateComponents.hour = 10
                        dateComponents.minute = 0
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                        print("dateComponents for notifs: \(dateComponents)")
                        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
                        center.add(request)
                        Analytics.logEvent("addedFoodItem", parameters: nil)
                        do{
                            try self.managedObjectContext.save()
                        } catch let error{
                            print(error)
                        }
                        
                    })
                    ,.default(Text("Cancel"))
                ])
            })
                .actionSheet(item: self.$customMealTapped, content: { item in
                    ActionSheet(title: Text("Options"), message: Text("You can choose to delete this meal, edit this meal, or cancel"), buttons: [
                        .default(Text("Delete Meal"), action: {
                            //TODO: Delete Meal
                        })
                        ,.default(Text("Edit Meal"), action: {
                            //TODO: Edit Meal
                        })
                        ,.default(Text("Cancel"))
                    ])
                })
            
                //MARK: Add Foods Item
                Button(action: {
                    self.showAddFoodItemSheet.toggle()
                    print("present sheet")
                }, label: {
                    Image("AddFoodItemThinOrange").renderingMode(.original)
                })
                    
        }
        
        .onAppear{
            for fontFamily in UIFont.familyNames {
                for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                    print("\(fontName)")
                }
            }
        }
        .sheet(item: self.$editFoodItem, content: { item in
            EditFoodItemPopUpView(foodItem: item, icon: item.wrappedSymbol, title: item.wrappedName, lastsFor: Int(item.wrappedStaysFreshFor))
        })
        .sheet(isPresented: self.$showAddFoodItemSheet, content: {
            AddFoodItemToPlannerSheet(meal: self.meal).environment(\.managedObjectContext, self.managedObjectContext)
        })
    }
}


struct CustomMealCell:View{
    @State var icon: String
    @State var title: String
    var body: some View{
        HStack{
            Text(self.icon)
                    .font(.custom("SFProDisplay", size: 16))
                    .padding(.leading, 8)
            Text(self.title)
                    .font(.custom("SFProDisplay", size: 16))
                    .multilineTextAlignment(.leading)
                        
            Spacer()
                    
            
            
        }
        .padding()
        .background(Rectangle().cornerRadius(12)
        .foregroundColor(Color("whiteAndGray"))
        .shadow(color: Color("shadows"), radius: 3))
    }
}
