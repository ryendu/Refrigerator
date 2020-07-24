//
//  AddFoodItemToPlannerSheet.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/17/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData

struct AddFoodItemToPlannerSheet: View {
    @FetchRequest(entity: StorageLocation.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocations: FetchedResults<StorageLocation>
    @State var meal: FoodPlannerMeal
    @State var selection: FoodItem? = nil
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var customIcon = ""
    @State var customTitle = ""
    @State var customSelection = false
    @State var showErroMessage = false
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel").foregroundColor(.orange)
                        }).padding()
                }
                Text("Add A Food Item To Your Planner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Text("Select a food Item to add to your planner Or add a custom meal")
                .font(.body)
                .padding()
                
                //MARK: Custom Meal
                Group{
                    Text("Custom Meal")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding()
                    HStack{
                        
                        TextField("emoji", text: self.$customIcon, onEditingChanged: {_ in
                            self.customSelection = true
                            self.selection = nil
                        }, onCommit: {
                            self.customSelection = true
                            self.selection = nil
                        })
                                .font(.custom("SFProDisplay", size: 16))
                                .padding(.leading, 8)
                        TextField("meal name", text: self.$customTitle, onEditingChanged: {_ in
                            self.customSelection = true
                            self.selection = nil
                        }, onCommit: {
                            self.customSelection = true
                            self.selection = nil
                        })
                                .font(.custom("SFProDisplay", size: 16))
                                .multilineTextAlignment(.leading)
                                    
                        Spacer()
                                
                        
                        
                    }
                    .padding()
                    .background(Rectangle().cornerRadius(12)
                    .foregroundColor(Color(self.customSelection ? "orange" : "whiteAndGray"))
                    .shadow(color: Color("shadows"), radius: 3)
                    .onTapGesture {
                        self.customSelection.toggle()
                        if self.customSelection == true{
                            self.selection = nil
                        }
                        }
                    )
                    .padding(.horizontal)
                }
                
                Text("Existing Food Items")
                .font(.headline)
                .fontWeight(.semibold)
                .padding()
                ForEach(self.storageLocations, id: \.self){storageLocation in
                    StorageLocationDropDownView(customSelection: self.$customSelection, selection: self.$selection, item: storageLocation).environment(\.managedObjectContext, self.managedObjectContext).padding()
                }
                
                if self.showErroMessage{
                    Text("Please select a food item or select a custom food item")
                        .foregroundColor(.red)
                        .padding()
                }
                Button(action: {
                    if self.selection != nil && self.customSelection == false{
                        self.showErroMessage = false
                        self.meal.addToFoodItems(self.selection!)
                        do{
                            try self.managedObjectContext.save()
                            simpleSuccess()
                            self.presentationMode.wrappedValue.dismiss()
                        }catch{
                            print(error)
                        }
                    }else if self.customSelection == true{
                        self.showErroMessage = false
                        let newMealItem = MealItem(context: self.managedObjectContext)
                        newMealItem.name = self.customTitle
                        newMealItem.icon = self.customIcon
                        self.meal.addToMealItems(newMealItem)
                        do{
                            try self.managedObjectContext.save()
                            simpleSuccess()
                            self.presentationMode.wrappedValue.dismiss()
                        }catch{
                            print(error)
                        }
                        
                    }else{
                        self.showErroMessage = true
                    }
                }
                    , label: {
                        Image("addOrange").renderingMode(.original)
                }
                    
    )
                Spacer()
            }
        }
    }
}

struct StorageLocationDropDownView: View{
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    @Binding var customSelection: Bool
    @Binding var selection: FoodItem?
    @State var item: StorageLocation
    @State var showAllFoods = false
    var body: some View{
        VStack{
                Button(action: {
                    withAnimation(){
                        self.showAllFoods.toggle()
                    }
                }, label: {
                    HStack{
                        StorageCellFoodPlannerSelection(storageLocationIcon: item.wrappedSymbolName, storageLocationNumberOfItems: item.foodItemArray.count, storageLocationTitle: item.wrappedStorageName, storage: item, showAllFoods: self.$showAllFoods)
                        
                        
                    }
                }).buttonStyle(PlainButtonStyle())
                
                
            
            if self.showAllFoods{
                ForEach(self.item.foodItemArray, id: \.self){item in
                    Button(action: {
                        if self.selection != item {
                            self.selection = item
                            self.customSelection = false
                        }else {
                            self.selection = nil
                        }
                        simpleSuccess()
                        NotificationCenter.default.post(name: .shouldRefreshFoodPlannerSelection, object: nil)
                    }, label: {
                        if item.usesImage == false{
                        FoodItemCellFoodPlannerSelection(icon: item.wrappedSymbol, title: item.wrappedName, lastsUntil: self.addDays(days: Int(item.wrappedStaysFreshFor), dateCreated: item.wrappedInStorageSince), storageLocationIcon: item.origion?.symbolName ?? "", selection: self.$selection, item: item)
                        }else {
                            FoodItemCellFoodPlannerSelectionImage(image: item.image, title: item.wrappedName, lastsUntil: self.addDays(days: Int(item.wrappedStaysFreshFor), dateCreated: item.wrappedInStorageSince), storageLocationIcon: item.origion?.symbolName ?? "", selection: self.$selection, item: item)
                        }
                        }).buttonStyle(PlainButtonStyle())
                    
                        
                    
                }
                .animation(.spring())
            }
            
            
        }
    }
}
