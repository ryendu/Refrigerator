//
//  IndivisualRefrigeratorView.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/5/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData
import VisionKit
import Vision
import Combine
import UIKit
import Firebase


struct IndivisualRefrigeratorView: View {
    var storageIndex: StorageLocation
    func addDays (days: Int, dateCreated: Date) -> Date{
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: dateCreated)!
        print("Modified date: \(modifiedDate)")
        return modifiedDate
    }
    
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @FetchRequest(entity: FoodItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.staysFreshFor, ascending: true)]) var foodItem: FetchedResults<FoodItem>
    @FetchRequest(entity: StorageLocation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StorageLocation.storageName, ascending: true)]) var storageLocation: FetchedResults<StorageLocation>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showEatActionSheet = false
    @Binding var showingView: String?
    @Binding var scan: VNDocumentCameraScan?
    @Binding var image: [CGImage]?
    @State var foodItemTapped: FoodItem? = nil
    @State var showAddToShoppingListAlert: ShoppingListItem? = nil
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    func possiblyDoSomething(withPercentAsDecimal percent: Double) -> Bool{
        func simplify(top:Int, bottom:Int) -> (newTop:Int, newBottom:Int) {

            var x = top
            var y = bottom
            while (y != 0) {
                let buffer = y
                y = x % y
                x = buffer
            }
            let hcfVal = x
            let newTopVal = top/hcfVal
            let newBottomVal = bottom/hcfVal
            return(newTopVal, newBottomVal)
        }
        let denomenator = simplify(top:Int(percent * 100), bottom: 100)
        var returnValue = false
        print(denomenator)
        if Int.random(in: 1...denomenator.newBottom) == 1 {
        returnValue = true
      }
       return returnValue
    }
    @State var editFoodItem = false
    @State var showAddFoodItemSheet = false

    var body: some View {
        GeometryReader{ geo in
            VStack{
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        
                        
                        
                        
                        if self.editFoodItem == false {
                            Text("Long hold for more options").padding()
                            .font(.custom("SFCompactDisplay", size: 16))
                            .foregroundColor(.gray)
                        
                        ForEach(self.storageIndex.foodItemArray, id: \.self) { item in
                            RefrigeratorItemCell(icon: item.wrappedSymbol, title: item.wrappedName, lastsUntil: self.addDays(days: Int(item.wrappedStaysFreshFor), dateCreated: item.wrappedInStorageSince), storageLocationIcon: item.origion?.symbolName ?? "", item: item)
                            .onTapGesture {
                                simpleSuccess()
                                self.foodItemTapped = item
                           }
                            
                            .padding(.bottom)
                        }
                            
                            
                        } else {
                            ForEach(self.storageIndex.foodItemArray, id: \.self) { item in
                                DetectItemCoreDataCell(foodsToDisplay: item)
                            }
                        }
                        NavigationLink(destination: ExamineRecieptView(image: self.$image, showingView: self.$showingView, scan: self.$scan), tag: "results", selection: self.$showingView, label: {Text("")})
                    }
                    .navigationBarItems(trailing: HStack{
                        if self.editFoodItem == false{
                        Button(action: {
                    self.editFoodItem.toggle()
                    
                }, label: {
                    Text("Edit").layoutPriority(1)
                        
                            }).padding(6)
                            
                        }else{
                            Button(action: {
                                self.editFoodItem.toggle()
                                addToDailyGoal()
                                                refreshDailyGoalAndStreak()
                            }, label: {
                                Text("Done").layoutPriority(1)
                                    
                                        }).padding(6)
                        }
                        
    //                    Button(action: {
    //                        self.refrigeratorViewModel.isInAddFridgeItemView.toggle()
    //                    }, label: {
    //                        Image("plus")
    //                            .renderingMode(.original)
    //
    //                        }).padding(6)
                        
                        Button(action: {
                            self.showAddFoodItemSheet.toggle()
                        },label: {
                            Image(systemName: "plus")
                            
                        })
                        
                        
                        
                    })

                        .navigationBarTitle(self.storageIndex.wrappedStorageName)
                        
                        
    //                .sheet(isPresented: $refrigeratorViewModel.isInAddFridgeItemView, content: {
    //                    AddFoodItemSheet(storage: self.storageIndex).environmentObject(refrigerator).environment(\.managedObjectContext, self.managedObjectContext)
    //                })
                    
                    
                    
                    
                    
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
                            print("ate some of \(item)")
                            addToDailyGoal()
                                    refreshDailyGoalAndStreak()
                        })
                        
                        ,.default(Text("Duplicate"), action: {
                            addToDailyGoal()
                                    refreshDailyGoalAndStreak()
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
                            newFoodItem.id = id
                            item.origion?.addToFoodItem(newFoodItem)
                            
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
                        ,.default(Text("Cancel"))
                    ])
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
                
                .sheet(isPresented: self.$showAddFoodItemSheet, content: {
                    AddAnyFoodItemsSheet(showingView: self.$showingView, scan: self.$scan, image: self.$image).environment(\.managedObjectContext, self.managedObjectContext).environmentObject(refrigerator)
                })
                
            }
        }
        
    }

}


struct ScanningView: UIViewControllerRepresentable {
    
    private let completionHandler: ([CGImage]?, VNDocumentCameraScan?) -> Void
    
    init(completion: @escaping ([CGImage]?, VNDocumentCameraScan?) -> Void) {
        self.completionHandler = completion
    }
    
    
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScanningView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScanningView>) {
        
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        private var images = [CGImage]()
        private let completionHandler: ([CGImage]?, VNDocumentCameraScan?) -> Void
        
        init(completion: @escaping ([CGImage]?, VNDocumentCameraScan?) -> Void) {
            
            self.completionHandler = completion
        }
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil, nil)
            
        }
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            completionHandler(nil, nil)
        }
        
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    self.images.append(cgImage)
                }
            }
            
            completionHandler(images, scan)
            
        }
        
    }
    
}


