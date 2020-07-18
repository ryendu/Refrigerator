//
//  FoodPlannerMeal+CoreDataProperties.swift
//  
//
//  Created by Ryan Du on 7/17/20.
//
//

import Foundation
import CoreData


extension FoodPlannerMeal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodPlannerMeal> {
        return NSFetchRequest<FoodPlannerMeal>(entityName: "FoodPlannerMeal")
    }

    @NSManaged public var mealTitle: String?
    @NSManaged public var order: Int16
    @NSManaged public var foodItems: NSSet?
    @NSManaged public var planner: FoodPlanner?
    @NSManaged public var mealItems: NSSet?
    
    public var foodItemsArray: [FoodItem] {
        let set = foodItems?.sortedArray(using: [NSSortDescriptor(keyPath: \FoodItem.name, ascending: true)]) as! [FoodItem]
        return set
    }
    public var mealItemsArray: [MealItem] {
        let set = mealItems?.sortedArray(using: [NSSortDescriptor(keyPath: \MealItem.name, ascending: true)]) as! [MealItem]
        return set
    }
}

// MARK: Generated accessors for foodItems
extension FoodPlannerMeal {

    @objc(addFoodItemsObject:)
    @NSManaged public func addToFoodItems(_ value: FoodItem)

    @objc(removeFoodItemsObject:)
    @NSManaged public func removeFromFoodItems(_ value: FoodItem)

    @objc(addFoodItems:)
    @NSManaged public func addToFoodItems(_ values: NSSet)

    @objc(removeFoodItems:)
    @NSManaged public func removeFromFoodItems(_ values: NSSet)

}

// MARK: Generated accessors for mealItems
extension FoodPlannerMeal {

    @objc(addMealItemsObject:)
    @NSManaged public func addToMealItems(_ value: MealItem)

    @objc(removeMealItemsObject:)
    @NSManaged public func removeFromMealItems(_ value: MealItem)

    @objc(addMealItems:)
    @NSManaged public func addToMealItems(_ values: NSSet)

    @objc(removeMealItems:)
    @NSManaged public func removeFromMealItems(_ values: NSSet)

}
