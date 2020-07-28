//
//  MealItem+CoreDataProperties.swift
//  
//
//  Created by Ryan Du on 7/17/20.
//
//

import Foundation
import CoreData


extension MealItem: Identifiable{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealItem> {
        return NSFetchRequest<MealItem>(entityName: "MealItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var icon: String?
    @NSManaged public var foodPlanner: FoodPlannerMeal?

}
