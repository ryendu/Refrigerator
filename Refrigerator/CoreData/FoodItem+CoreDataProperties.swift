//
//  FoodItem+CoreDataProperties.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/9/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//
//

import Foundation
import CoreData


extension FoodItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodItem> {
        return NSFetchRequest<FoodItem>(entityName: "FoodItem")
    }

    @NSManaged public var inStorageSince: Date?
    @NSManaged public var inWhichStorage: String?
    @NSManaged public var name: String?
    @NSManaged public var staysFreshFor: Int16
    @NSManaged public var symbol: String?
    @NSManaged public var origion: StorageLocation?

    public var wrappedInStorageSince: Date {
        inStorageSince ?? Date()
    }
    public var wrappedName: String {
        name ?? "Unknown Food Item"
    }
    public var wrappedInWhichStorage: String {
        inWhichStorage ?? "Unknown Storage"
    }
    
    public var wrappedStaysFreshFor: Int16 {
        staysFreshFor
    }
    public var wrappedSymbol: String {
        symbol ?? "⍰"
    }
    

}

