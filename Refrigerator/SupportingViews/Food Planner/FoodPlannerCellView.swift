//
//  FoodPlannerCellView.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/17/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct FoodPlannerCellView: View {
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: FoodPlanner.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoodPlanner.trackDate, ascending: true)], predicate:
        NSPredicate(format: "trackDate == %@", refrigerator.trackDate as CVarArg)) var foodPlanners: FetchedResults<FoodPlanner>
    var body: some View {
        VStack{
            if self.foodPlanners.count >= 1{
                ForEach(self.foodPlanners, id: \.self){planner in
                    VStack{
                        ForEach(planner.mealsArray, id: \.self){meal in
                            MealCell(meal: meal).padding()
                        }
                    }
                }
            }else {
                Spacer()
                Text("You do not have a food planner for this date, click below to add one.")
                    .font(.custom("SFProDisplayMedium", size: 21))
                    .foregroundColor(Color(hex: "464646"))
                    .padding()
                Button(action: {
                    let newFoodPlanner = FoodPlanner(context: self.managedObjectContext)
                    let breakfeast = FoodPlannerMeal(context: self.managedObjectContext)
                    breakfeast.mealTitle = "Breakfeast"
                    breakfeast.order = Int16(1)
                    let lunch = FoodPlannerMeal(context: self.managedObjectContext)
                    lunch.mealTitle = "Lunch"
                    lunch.order = Int16(2)
                    let dinner = FoodPlannerMeal(context: self.managedObjectContext)
                    dinner.mealTitle = "Dinner"
                    dinner.order = Int16(3)
                    let snacks = FoodPlannerMeal(context: self.managedObjectContext)
                    snacks.mealTitle = "Snacks"
                    snacks.order = Int16(4)
                    newFoodPlanner.trackDate = self.refrigeratorViewModel.trackDate
                    newFoodPlanner.addToMeals(breakfeast)
                    newFoodPlanner.addToMeals(lunch)
                    newFoodPlanner.addToMeals(dinner)
                    newFoodPlanner.addToMeals(snacks)
                    do{
                        try self.managedObjectContext.save()
                        print("saved with trackDate: \(self.refrigeratorViewModel.trackDate)")
                    }catch{
                        print("error saving new planner \(error.localizedDescription)")
                    }
                }, label: {
                    Image("AddAFoodPlannerButton")
                        .renderingMode(.original)
                }).padding()
            }
        }
    }
}

struct FoodPlannerCellView_Previews: PreviewProvider {
    static var previews: some View {
        FoodPlannerCellView()
    }
}
