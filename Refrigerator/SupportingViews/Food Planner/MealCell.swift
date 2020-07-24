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
    @State var editCustomMealSheet: MealItem? = nil
    @State var showAddToShoppingListAlert: ShoppingListItem? = nil
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>

    var body: some View {
        VStack{
            HStack(){
                Text(meal.mealTitle ?? "")
                    .font(.custom("SFProDisplay-Bold", size: 27))
                    .foregroundColor(Color("lightGray"))
                    .padding()
                    .multilineTextAlignment(.leading)
                Spacer()
                //MARK: Add Foods Item
                Group{
                    Button(action: {
                        self.showAddFoodItemSheet.toggle()
                        print("present sheet")
                    }, label: {
                        Image("AddFoodItemThinOrange").renderingMode(.original)
                        }).padding()
                        .sheet(isPresented: self.$showAddFoodItemSheet, content: {
                            AddFoodItemToPlannerSheet(meal: self.meal).environment(\.managedObjectContext, self.managedObjectContext)
                        })
                }
            }
            
            //MARK: FOODS
            Group{
                ForEach(self.meal.mealItemsArray, id: \.self){index in
                    CustomMealCell(icon: index.icon ?? "", title: index.name ?? "")
                        .onTapGesture {
                            self.customMealTapped = index
                    }.padding()
                }.actionSheet(item: self.$customMealTapped, content: { item in
                    ActionSheet(title: Text("Options"), message: Text("You can choose to delete this meal, edit this meal, or cancel"), buttons: [
                        .default(Text("Delete Meal"), action: {
                            self.managedObjectContext.delete(item)
                            do{
                                try self.managedObjectContext.save()
                            }catch{
                                print("error: \(error.localizedDescription)")
                            }
                        })
                        ,.default(Text("Edit Meal"), action: {
                            self.editCustomMealSheet = item
                        })
                        ,.default(Text("Cancel"))
                    ])
                })
                    .sheet(item: self.$editCustomMealSheet, content: { item in
                        EditCustomMealSheet(item: item)
                    })
            }
            Group{
                ForEach(self.meal.foodItemsArray, id: \.self){ index in
                    
                    RefrigeratorItemCell(icon: index.wrappedSymbol, title: index.wrappedName, lastsUntil: self.addDays(days: Int(index.wrappedStaysFreshFor), dateCreated: index.wrappedInStorageSince), storageLocationIcon: index.origion?.symbolName ?? "", item: index)
                        .onTapGesture {
                            self.foodItemTapped = index
                    }
                    
                    
                }
                .sheet(item: self.$editFoodItem, content: { item in
                    EditFoodItemPopUpView(foodItem: item, icon: item.wrappedSymbol, title: item.wrappedName, lastsFor: Int(item.wrappedStaysFreshFor))
                })

                    .alert(item: self.$showAddToShoppingListAlert, content: { item in
                        Alert(title: Text("Add \(item.name) to shopping list?"), message: Text("Click add to add \(item.name) to your shopping list."), primaryButton:
                            .default(Text("add"), action: {
                                let newShoppingItem = ShoppingList(context: self.managedObjectContext)
                                newShoppingItem.name = item.name
                                newShoppingItem.icon = item.icon
                                newShoppingItem.checked = false
                                do{
                                    try self.managedObjectContext.save()
                                } catch let error{
                                print(error)
                                }
                                Analytics.logEvent("addedShoppingListItem", parameters: nil)
                            }), secondaryButton: .cancel(Text("Don't Add")))
                    })
                    .actionSheet(item: self.$foodItemTapped, content: { item in // << activated on item
                        ActionSheet(title: Text("More Options"), message: Text("Chose what to do with this food item"), buttons: [
                            .default(Text("Eat All"), action: {
                                addToDailyGoal()
                                refreshDailyGoalAndStreak()
                                self.user.first?.foodsEaten += Int32(1)
                                let center = UNUserNotificationCenter.current()
                                center.removePendingNotificationRequests(withIdentifiers: [item.wrappedID.uuidString])
                                self.showAddToShoppingListAlert = ShoppingListItem(name: item.wrappedName, icon: item.wrappedSymbol)
                                self.managedObjectContext.delete(item)
                                try? self.managedObjectContext.save()
                            })
                            ,.default(Text("Throw Away"), action: {
                                self.user.first?.foodsThrownAway += Int32(1)
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
                                if item.usesImage{
                                    newFoodItem.usesImage = true
                                    newFoodItem.image = item.image
                                }else{
                                    newFoodItem.symbol = item.symbol
                                }
                                newFoodItem.name = item.name
                                newFoodItem.inStorageSince = Date()
                                newFoodItem.origion = StorageLocation(context: self.managedObjectContext)
                                newFoodItem.origion?.storageName = item.origion?.storageName
                                newFoodItem.origion?.symbolName = item.origion?.symbolName
                                newFoodItem.id = id
                                addToDailyGoal()
                                refreshDailyGoalAndStreak()
                                self.meal.addToFoodItems(newFoodItem)
                                let center = UNUserNotificationCenter.current()
                                let content = UNMutableNotificationContent()
                                content.title = "Eat This Food Soon"
                                let date = Date()
                                let twoDaysBefore = self.addDays(days: Int(item.staysFreshFor) - Int(self.user.first?.remindDate ?? Int16(2)), dateCreated: date)
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
                            ,.default(Text("Remove from meal plan"), action: {
                                self.meal.removeFromFoodItems(item)
                                try? self.managedObjectContext.save()
                            })
                            ,.default(Text("Cancel"))
                        ])
                    })
            }
            
            if self.meal.mealItemsArray.count == 0 && self.meal.foodItemsArray.count == 0 {
                Text("There are no foods for this meal")
                    .font(.custom("SFCompactText-Thin", size: 20))
                    .padding()
            }
            
            
            Divider().padding()
            
        }
            
        .onAppear{
            for fontFamily in UIFont.familyNames {
                for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                    print("\(fontName)")
                }
            }
        }
        
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
