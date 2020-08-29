//
//  DetectItemCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/21/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData
import Firebase

struct DetectItemCell: View {
    @Binding var foodsToDisplay: [refrigeItem]
    var index: Int
    @State var icon: String
    @State var title: String
    @State var lastsFor: Int
    @FetchRequest(entity: StorageLocation.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    var body: some View {
        HStack{
            TextField(icon, text: $icon)
            .frame(width: 40, height: 40)
            .multilineTextAlignment(.center)
            .font(.custom("SFProDisplay", size: 50))
        VStack{
            HStack{
                TextField(title, text: $title)
                            .font(.custom("SFProDisplay", size: 20))
                            .multilineTextAlignment(.leading)
                Spacer()
                
                Button(action: {
                    let storageLocationCount = self.storageLocation.count
                    let strg = self.foodsToDisplay[self.index].addToStorage
                    if let indx = self.storageLocation.firstIndex(of: strg){
                        if indx + 1 <= (storageLocationCount - 1){
                            self.foodsToDisplay[self.index].addToStorage = self.storageLocation[indx+1]
                        }else{
                            if let stg = self.storageLocation.first{
                                self.foodsToDisplay[self.index].addToStorage = stg
                            }
                        }
                    }
                }, label: {
                    Image(self.foodsToDisplay[index].addToStorage.wrappedSymbolName )
                    .resizable()
                    .scaledToFit()
                    .frame(width:50, height:50, alignment: .trailing)
                    .padding()
                    }).buttonStyle(PlainButtonStyle())
            }
        HStack {
            
                
            
               
            
            Stepper(value: $lastsFor, in: 1...1000) {
                Text("lasts for \((lastsFor)) days")
                .font(.custom("SFCompactDisplay", size: 16))
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
struct AddFoodItemListEditCell: View {
    @Environment(\.managedObjectContext) var moc
    @Binding var searchResults: [SearchDisplayObject]
    @FetchRequest(entity: StorageLocation.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    var searchResult: SearchDisplayObject
    @State var title: String
    @State var lastsFor: Int
    @FetchRequest(entity: User.entity(),sortDescriptors: []) var user: FetchedResults<User>
    @State var usingStorageLocation: StorageLocation? = nil
    
    var body: some View {
        HStack{
            Image(uiImage: self.searchResult.image)
                .resizable()
                .frame(width: 50, height: 50, alignment: .leading)
                .padding()
            
        VStack{
            HStack{
                TextField(title, text: $title)
                    .font(.custom("SFProDisplay", size: 20))
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.6)
                Spacer()
                
                Button(action: {
                    let storageLocationCount = self.storageLocation.count
                    if let strg = self.usingStorageLocation, let indx = self.storageLocation.firstIndex(of: strg){
                        if indx + 1 <= (storageLocationCount - 1){
                            self.usingStorageLocation = self.storageLocation[indx+1]
                        }else{
                            self.usingStorageLocation = self.storageLocation.first
                        }
                    }
                }, label: {
                    Image(self.usingStorageLocation?.wrappedSymbolName ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width:50, height:50, alignment: .trailing)
                    .padding()
                    }).buttonStyle(PlainButtonStyle())
            }
        HStack {
            
                
            
               
            
            Stepper(value: $lastsFor, in: 1...1000) {
                Text("lasts for \((lastsFor)) days")
                .font(.custom("SFCompactDisplay", size: 16))
                .foregroundColor(Color(hex: "868686"))
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 80)
            }
            Button(action: {
                if let indx = self.searchResults.firstIndex(of: self.searchResult){
                    self.searchResults.remove(at: indx)
                }
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
    .onAppear{
            if self.storageLocation.count > 0{
                self.usingStorageLocation = self.storageLocation.first
            }
    }
        .onReceive(NotificationCenter.default.publisher(for: .addSelecedFoodItems)) {_ in

            DispatchQueue.main.asyncAfter(deadline: .now()) {
                //TODOING RN
                let id = UUID()
                let newFoodItem = FoodItem(context: self.moc)
                newFoodItem.staysFreshFor = Int16(self.lastsFor)
                newFoodItem.usesImage = true
                if let image = self.searchResult.image.pngData(){
                newFoodItem.image = image
                }
                newFoodItem.name = self.searchResult.title
                newFoodItem.inStorageSince = Date()
                newFoodItem.id = id
                self.usingStorageLocation?.addToFoodItem(newFoodItem)
                
                Analytics.logEvent("addedFoodItem", parameters: nil)
                   do{
                       try self.moc.save()
                   } catch let error{
                   print(error)
                   }
                addToDailyGoal()
                refreshDailyGoalAndStreak()
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = "Eat This Food Soon"
                let date = Date()

                let twoDaysBefore = addDays(days: 7 - Int(self.user.first?.remindDate ?? Int16(2)), dateCreated: date)
                content.body = "Your food item, \(newFoodItem.wrappedName) is about to go bad in 2 days."
                content.sound = UNNotificationSound.default
                var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: twoDaysBefore)
                dateComponents.hour = 10
                dateComponents.minute = 0
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                print("dateComponents for notifs: \(dateComponents)")
                let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
                center.add(request)
                try? self.moc.save()
           }
        }
}
}
struct DetectItemCoreDataCell: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var foodsToDisplay: FoodItem
    @FetchRequest(entity: StorageLocation.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @State var icon = ""
    @State var title = ""
    @State var lastsFor = 7
    @State var usingStorageLocation: StorageLocation? = nil
    @FetchRequest(entity: User.entity(),sortDescriptors: []) var user: FetchedResults<User>
    var body: some View {
        HStack{
            if self.foodsToDisplay.usesImage == false{
                TextField(icon, text: $icon)
                .frame(width: 40, height: 40)
                .multilineTextAlignment(.center)
                .font(.custom("SFProDisplay", size: 50))
            }else {
                Image(uiImage: UIImage(data: self.foodsToDisplay.image) ?? UIImage(named: "placeholder")!)
                .resizable()
                .scaledToFit()
                    .frame(width: 55, height: 55, alignment: .leading)
                .padding()
            }
        VStack{
            HStack{
                
                TextField(title, text: $title)
                            .font(.custom("SFProDisplay", size: 20))
                            .multilineTextAlignment(.leading)
                Spacer()
                Button(action: {
                    let storageLocationCount = self.storageLocation.count
                    if let strg = self.usingStorageLocation, let indx = self.storageLocation.firstIndex(of: strg){
                        if indx + 1 <= (storageLocationCount - 1){
                            self.usingStorageLocation = self.storageLocation[indx+1]
                        }else{
                            self.usingStorageLocation = self.storageLocation.first
                        }
                    }
                }, label: {
                    Image(self.usingStorageLocation?.wrappedSymbolName ?? "Fridge pastel icon yellow")
                    .resizable()
                    .scaledToFit()
                    .frame(width:50, height:50, alignment: .trailing)
                    .padding()
                    }).buttonStyle(PlainButtonStyle())
            }
        HStack {
            
                
            
               
            
            Stepper(value: $lastsFor, in: 1...1000) {
                Text("lasts for \((lastsFor)) days")
                .font(.custom("SFCompactDisplay", size: 16))
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
                self.usingStorageLocation = self.foodsToDisplay.origion
            })
        .onDisappear(perform: {
                self.foodsToDisplay.name = self.title
                self.foodsToDisplay.symbol = self.icon
                self.foodsToDisplay.staysFreshFor = Int16(self.lastsFor)
            self.foodsToDisplay.origion = self.usingStorageLocation ?? self.foodsToDisplay.origion
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [self.foodsToDisplay.wrappedID.uuidString])
            
            let content = UNMutableNotificationContent()
            content.title = "Eat This Food Soon"
            let date = Date()
            

            let twoDaysBefore = addDays(days: 7 - Int(self.user.first?.remindDate ?? Int16(2)), dateCreated: date)
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
        
