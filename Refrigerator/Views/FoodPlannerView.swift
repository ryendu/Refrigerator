//
//  FoodPlannerView.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/16/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import Firebase
import CoreData

struct FoodPlannerView: View {
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @State var date = ""
    var trackDate: String

    var body: some View {
        NavigationView {
            GeometryReader{ geo in
                    VStack{
                        ScrollView(.vertical, showsIndicators: false, content: {
                            HStack{
                                Button(action: {
                                    let calendar = Calendar.current
                                    let date1 = self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)
                                    var dateComponent = DateComponents()
                                    let components1 = calendar.dateComponents([.year, .month, .day], from: date1!)
                                    let month1 = components1.month
                                    let day1 = components1.day
                                    print("track if condition date: \(String(describing: day1))")
                                    
                                    if month1 != 1 || day1 != 1{
                                        dateComponent.day = -1
                                        let futureDate = Calendar.current.date(byAdding: dateComponent, to: self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)!)
                                        print("future date: \(String(describing: futureDate))")
                                        self.refrigeratorViewModel.trackDate = self.refrigeratorViewModel.getTrackDate(with: futureDate!)
                                        
                                    } else {
                                        var specialComponents = DateComponents()
                                        let currentYear = Calendar.current.component(.year, from: self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)!)
                                        specialComponents.day = 31
                                        specialComponents.month = 12
                                        specialComponents.year = currentYear - 1
                                        let futureDate = Calendar.current.date(from: specialComponents)
                                        self.refrigeratorViewModel.trackDate = self.refrigeratorViewModel.getTrackDate(with: futureDate!)
                                    }
                                    
                                    
                                    self.updateSelfDate()
                                    Analytics.logEvent("navigatedThroughFoodPlannerViewsDays", parameters: nil)

                                    
                                }, label: {
                                    Image(systemName: "chevron.left")
                                }).padding()
                                Text(self.date).padding()
                                Spacer()
                                Button(action: {
                                    //[0, 7, 3, 1, 2, 0, 2, 0]
                                    let calendar = Calendar.current
                                    let date = self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)
                                    var dateComponent = DateComponents()
                                    let components = calendar.dateComponents([.year, .month, .day], from: date!)
                                    let month = components.month
                                    let day = components.day
                                    
                                    if month == 12 && day == 31{
                                        
                                        
                                        var specialComponents = DateComponents()
                                        let currentYear = Calendar.current.component(.year, from: self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)!)
                                        specialComponents.day = 1
                                        specialComponents.month = 1
                                        specialComponents.year = currentYear + 1
                                        let futureDate = Calendar.current.date(from: specialComponents)
                                        self.refrigeratorViewModel.trackDate = self.refrigeratorViewModel.getTrackDate(with: futureDate!)
                                        
                                    } else {
                                        dateComponent.day = 1
                                        let futureDate = Calendar.current.date(byAdding: dateComponent, to: self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)!)
                                        self.refrigeratorViewModel.trackDate = self.refrigeratorViewModel.getTrackDate(with: futureDate!)
                                        
                                    }
                                    
                                    self.updateSelfDate()
                                    Analytics.logEvent("navigatedThroughFoodPlannerViewsDays", parameters: nil)
                                }, label: {
                                    Image(systemName: "chevron.right")
                                }).padding()
                            }
                            //MARK: Below is the divider
                            Divider()
                            Spacer()
                            //MARK: SHOW THE FOOD PLANNER HERE
                            FoodPlannerCellView()
                            
                            
                            Spacer()
                        })
                        
                    }
                    .navigationBarTitle("Food Planner")
                        .onAppear(perform: {
                            self.updateSelfDate()
                            
                    })
                    
            }
                
            
            
            
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
    func updateSelfDate() {
        let calendar = Calendar.current
        var stringMonth = ""
        let date = self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)
        let components = calendar.dateComponents([.year, .month, .day], from: date!)
        let year =  components.year
        let month = components.month
        let day = components.day
        if month == 1 {
            stringMonth = "January"
        } else if month == 2 {
            stringMonth = "Febuary"
        } else if month == 3 {
            stringMonth = "March"
        } else if month == 4 {
            stringMonth = "April"
        } else if month == 5 {
            stringMonth = "May"
        } else if month == 6 {
            stringMonth = "June"
        } else if month == 7{
            stringMonth = "July"
        } else if month == 8 {
            stringMonth = "August"
        } else if month == 9 {
            stringMonth = "September"
        } else if month == 10 {
            stringMonth = "October"
        } else if month == 11 {
            stringMonth = "November"
        } else if month == 12 {
            stringMonth = "December"
        }
        self.date = "\(stringMonth) \(day!), \(year!)"
        print("trackDate: \(self.refrigeratorViewModel.trackDate)")
        print(self.date)
        
    }
}


struct FoodPlannerViewiPad: View {
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @State var date = ""
    var trackDate: String

    var body: some View {
            GeometryReader{ geo in
                    VStack{
                        ScrollView(.vertical, showsIndicators: false, content: {
                            HStack{
                                Button(action: {
                                    let calendar = Calendar.current
                                    let date1 = self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)
                                    var dateComponent = DateComponents()
                                    let components1 = calendar.dateComponents([.year, .month, .day], from: date1!)
                                    let month1 = components1.month
                                    let day1 = components1.day
                                    print("track if condition date: \(String(describing: day1))")
                                    
                                    if month1 != 1 || day1 != 1{
                                        dateComponent.day = -1
                                        let futureDate = Calendar.current.date(byAdding: dateComponent, to: self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)!)
                                        print("future date: \(String(describing: futureDate))")
                                        self.refrigeratorViewModel.trackDate = self.refrigeratorViewModel.getTrackDate(with: futureDate!)
                                        
                                    } else {
                                        var specialComponents = DateComponents()
                                        let currentYear = Calendar.current.component(.year, from: self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)!)
                                        specialComponents.day = 31
                                        specialComponents.month = 12
                                        specialComponents.year = currentYear - 1
                                        let futureDate = Calendar.current.date(from: specialComponents)
                                        self.refrigeratorViewModel.trackDate = self.refrigeratorViewModel.getTrackDate(with: futureDate!)
                                    }
                                    
                                    
                                    self.updateSelfDate()
                                    Analytics.logEvent("navigatedThroughFoodPlannerViewsDays", parameters: nil)

                                    
                                }, label: {
                                    Image(systemName: "chevron.left")
                                }).padding()
                                Text(self.date).padding()
                                Spacer()
                                Button(action: {
                                    //[0, 7, 3, 1, 2, 0, 2, 0]
                                    let calendar = Calendar.current
                                    let date = self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)
                                    var dateComponent = DateComponents()
                                    let components = calendar.dateComponents([.year, .month, .day], from: date!)
                                    let month = components.month
                                    let day = components.day
                                    
                                    if month == 12 && day == 31{
                                        
                                        
                                        var specialComponents = DateComponents()
                                        let currentYear = Calendar.current.component(.year, from: self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)!)
                                        specialComponents.day = 1
                                        specialComponents.month = 1
                                        specialComponents.year = currentYear + 1
                                        let futureDate = Calendar.current.date(from: specialComponents)
                                        self.refrigeratorViewModel.trackDate = self.refrigeratorViewModel.getTrackDate(with: futureDate!)
                                        
                                    } else {
                                        dateComponent.day = 1
                                        let futureDate = Calendar.current.date(byAdding: dateComponent, to: self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)!)
                                        self.refrigeratorViewModel.trackDate = self.refrigeratorViewModel.getTrackDate(with: futureDate!)
                                        
                                    }
                                    
                                    self.updateSelfDate()
                                    Analytics.logEvent("navigatedThroughFoodPlannerViewsDays", parameters: nil)
                                }, label: {
                                    Image(systemName: "chevron.right")
                                }).padding()
                            }
                            //MARK: Below is the divider
                            Divider()
                            Spacer()
                            //MARK: SHOW THE FOOD PLANNER HERE
                            FoodPlannerCellView()
                            
                            
                            Spacer()
                        })
                        
                    }
                    .navigationBarTitle("Food Planner")
                        .onAppear(perform: {
                            self.updateSelfDate()
                            
                    })
                    
            }
                
            
            
    }
    func updateSelfDate() {
        let calendar = Calendar.current
        var stringMonth = ""
        let date = self.refrigeratorViewModel.getDate(from: self.refrigeratorViewModel.trackDate)
        let components = calendar.dateComponents([.year, .month, .day], from: date!)
        let year =  components.year
        let month = components.month
        let day = components.day
        if month == 1 {
            stringMonth = "January"
        } else if month == 2 {
            stringMonth = "Febuary"
        } else if month == 3 {
            stringMonth = "March"
        } else if month == 4 {
            stringMonth = "April"
        } else if month == 5 {
            stringMonth = "May"
        } else if month == 6 {
            stringMonth = "June"
        } else if month == 7{
            stringMonth = "July"
        } else if month == 8 {
            stringMonth = "August"
        } else if month == 9 {
            stringMonth = "September"
        } else if month == 10 {
            stringMonth = "October"
        } else if month == 11 {
            stringMonth = "November"
        } else if month == 12 {
            stringMonth = "December"
        }
        self.date = "\(stringMonth) \(day!), \(year!)"
        print("trackDate: \(self.refrigeratorViewModel.trackDate)")
        print(self.date)
        
    }
}
