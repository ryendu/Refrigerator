//
//  SettingsView.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/2/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//
import Combine
import SwiftUI
import GoogleMobileAds

struct SettingsView: View{
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    func foodsEaten() -> String {
        let foodsEaten = Double(self.user.first?.foodsEaten ?? 0)
        let totalFoods = foodsEaten + Double(self.user.first?.foodsThrownAway ?? 0)
        print("this ran 253")
        if totalFoods != 0{
            print("foods eaten function 253: \(((foodsEaten / totalFoods) * 100.0).rounded()), foodsEaten: \(foodsEaten), total foods: \(totalFoods)")
        return String(((foodsEaten / totalFoods) * 100.0).rounded())
        }else {
            print("total foods is 0 253")
            return String(0)
        }
    }
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
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    @State var name = ""
    @State var remindDate = 2
    var body: some View{
        NavigationView{
            GeometryReader{ geo in
                List{
                    Section{
                   Text("Name")
                    .font(.title)
                        HStack{
                            TextField("name", text: self.$name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                self.user[0].name = self.name
                                try? self.managedObjectContext.save()
                            }, label: {
                                Text("Save")
                                })
                        }
                    }
                    Section{
                        Text("Premium")
                            .font(.title)
                        if self.refrigeratorViewModel.isPremiumPurchased() == false {
                        NavigationLink(destination: PremiumView(), label: {
                            Text("Upgrade to premium")
                            }).padding()
                        }else {
                            Text("Subscribed to premium")
                            Button(action: {
                                UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
                            },label: {
                                Text("Manage Premium Subscription")
                                }).padding()
                        }
                    }
                    
                    Section{
                        Text("Reminders")
                            .font(.title)
                        if self.refrigeratorViewModel.isPremiumPurchased() == false {
                        Text("You will be reminded 2 days before a food expires.")
                        }else {
                            HStack{
                                Stepper(value: self.$remindDate, in: 1...100) {
                                    Text("Be reminded of your food's expiration date \(self.remindDate) days before its expiration date")
                                }
                                
                                
                                Button(action: {
                                    self.user.first?.remindDate = Int16(self.remindDate)
                                    try? self.managedObjectContext.save()
                                }, label: {
                                    Text("Save")
                                })
                            }
                            Text("Note: Current food reminders will not be changed, only new food items will have this remind date.").font(.caption)
                        }
                    }
                    Section{
                        Text("Progress")
                        .font(.title)
                        Text("🌳 You have eaten \(self.foodsEaten()) percent of all your foods")
                     }
                    Section{
                    NavigationLink(destination: AboutDialougView(), label: {
                        Text("about dialoug")
                    })
                     }
                    Section{
                        if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 2 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)) && self.refrigeratorViewModel.isPremiumPurchased() == false{
                        GADBannerViewController()
                        .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                        }else {

                        }
                        
                    }
                    Section{
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://refrigerator.flycricket.io/terms.html")!)
                        }, label: {
                            Text("Terms And Conditions")
                        })
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://refrigerator.flycricket.io/privacy.html")!)
                        }, label: {
                            Text("Privacy Policy")
                        })
                    }
                    
                    Section{
                    NavigationLink(destination: FeedbackView(), label: {
                        Text("send feedback")
                    })
                     }
                    }.listStyle(GroupedListStyle())
                
            .navigationBarTitle("Settings")
            
            
        }
        }.navigationViewStyle(StackNavigationViewStyle())
            .onAppear{
                self.remindDate = Int(self.user.first?.remindDate ?? 2)
                self.name = self.user.first?.name ?? ""
        }
    }
}







//struct SettingsViewiPad: View{
//    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
//    func foodsEaten() -> String {
//        let foodsEaten = Double(self.user.first?.foodsEaten ?? 0)
//        let totalFoods = foodsEaten + Double(self.user.first?.foodsThrownAway ?? 0)
//        print("this ran 253")
//        if totalFoods != 0{
//            print("foods eaten function 253: \(((foodsEaten / totalFoods) * 100.0).rounded()), foodsEaten: \(foodsEaten), total foods: \(totalFoods)")
//        return String(((foodsEaten / totalFoods) * 100.0).rounded())
//        }else {
//            print("total foods is 0 253")
//            return String(0)
//        }
//    }
//    func possiblyDoSomething(withPercentAsDecimal percent: Double) -> Bool{
//        func simplify(top:Int, bottom:Int) -> (newTop:Int, newBottom:Int) {
//
//            var x = top
//            var y = bottom
//            while (y != 0) {
//                let buffer = y
//                y = x % y
//                x = buffer
//            }
//            let hcfVal = x
//            let newTopVal = top/hcfVal
//            let newBottomVal = bottom/hcfVal
//            return(newTopVal, newBottomVal)
//        }
//        let denomenator = simplify(top:Int(percent * 100), bottom: 100)
//        var returnValue = false
//        print(denomenator)
//        if Int.random(in: 1...denomenator.newBottom) == 1 {
//        returnValue = true
//      }
//       return returnValue
//    }
//    @Environment(\.managedObjectContext) var managedObjectContext
//    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
//    @State var name = ""
//    @State var remindDate = 2
//    var body: some View{
//            GeometryReader{ geo in
//                List{
//                    Section{
//                   Text("Name")
//                    .font(.title)
//                        HStack{
//                            TextField("name", text: self.$name)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            Button(action: {
//                                self.user[0].name = self.name
//                                try? self.managedObjectContext.save()
//                            }, label: {
//                                Text("Save")
//                                })
//                        }
//                    }
//                    Section{
//                        Text("Premium")
//                            .font(.title)
//                        if self.refrigeratorViewModel.isPremiumPurchased() == false {
//                        NavigationLink(destination: PremiumView(), label: {
//                            Text("Upgrade to premium")
//                            }).padding()
//                        }else {
//                            Text("Subscribed to premium")
//                            Button(action: {
//                                UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
//                            },label: {
//                                Text("Manage Premium Subscription")
//                                }).padding()
//                        }
//                    }
//
//                    Section{
//                        Text("Reminders")
//                            .font(.title)
//                        if self.refrigeratorViewModel.isPremiumPurchased() == false {
//                        Text("You will be reminded 2 days before a food expires.")
//                        }else {
//                            HStack{
//                                Stepper(value: self.$remindDate, in: 1...100) {
//                                    Text("Be reminded of your food's expiration date")
//                                }
//                                Text("Days before its expiration date").padding()
//
//                                Button(action: {
//                                    self.user.first?.remindDate = Int16(self.remindDate)
//                                    try? self.managedObjectContext.save()
//                                }, label: {
//                                    Text("Save")
//                                })
//                            }
//                            Text("Note: Current food reminders will not be changed, only new food items will have this remind date.").font(.caption)
//                        }
//                    }
//                    Section{
//                        Text("Progress")
//                        .font(.title)
//                        Text("🌳 You have eaten \(self.foodsEaten()) percent of all your foods")
//                     }
//                    Section{
//                    NavigationLink(destination: AboutDialougView(), label: {
//                        Text("about dialoug")
//                    })
//                     }
//                    Section{
//                        if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 2 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)) && self.refrigeratorViewModel.isPremiumPurchased() == false{
//                        GADBannerViewController()
//                        .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
//                        }else {
//
//                        }
//
//                    }
//
//                    Section{
//                    NavigationLink(destination: FeedbackView(), label: {
//                        Text("send feedback")
//                    })
//                     }
//                    }.listStyle(GroupedListStyle())
//
//            .navigationBarTitle("Settings")
//
//
//        }
//            .onAppear{
//                self.remindDate = Int(self.user.first?.remindDate ?? 2)
//                self.name = self.user[0].name ?? ""
//        }
//    }
//}
