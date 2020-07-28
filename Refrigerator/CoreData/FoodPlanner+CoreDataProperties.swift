//
//  FoodPlanner+CoreDataProperties.swift
//  
//
//  Created by Ryan Du on 7/16/20.
//
//

import Foundation
import CoreData


extension FoodPlanner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodPlanner> {
        return NSFetchRequest<FoodPlanner>(entityName: "FoodPlanner")
    }

    @NSManaged public var trackDate: String?
    @NSManaged public var meals: NSSet?
    
    public var mealsArray: [FoodPlannerMeal] {
        let set = meals?.sortedArray(using: [NSSortDescriptor(keyPath: \FoodPlannerMeal.order, ascending: true)]) as! [FoodPlannerMeal]
        return set
    }
    
}

// MARK: Generated accessors for meals
extension FoodPlanner {

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: FoodPlannerMeal)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: FoodPlannerMeal)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSSet)

}
