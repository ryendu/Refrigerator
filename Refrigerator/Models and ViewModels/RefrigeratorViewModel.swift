//
//  RefrigeratorViewModel.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/2/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

enum WhichView {
    case homeView
    case refrigeratorView
    case progressView
}
enum RCKeys: String {
    case homeCustomMessage
    case chanceOfPopups
    case numberOfAdsInHomeView
    case shoppingListDescriptionHomeView
    case noFoodItemsText
    case numberOfAdsNonHomeView
    case chanceOfBanners
    case requestReview
    case feedbackViewMessage
    case requestReviewPeriod
    case chanceOfReview
}
class RefrigeratorViewModel: ObservableObject {
    @Published var defaultValues =  ([
        "homeCustomMessage" : "" as NSObject,
        "chanceOfPopups" : 0.2 as NSObject,
        "numberOfAdsInHomeView" : 1 as NSObject,
        "shoppingListDescriptionHomeView" : "Making a shopping list for your weekly grocery run helps prevent food waste and helps you eat healthier" as NSObject,
        "noFoodItemsText" : "Start by adding a food to one of your fridges by going to the Refrigerator Tab in the middle down below 👇." as NSObject,
        "numberOfAdsNonHomeView" : 6 as NSObject,
        "chanceOfBanners" : 0.25 as NSObject,
        "requestReview" : false as NSObject, RCKeys.feedbackViewMessage.rawValue: "Hey there! If you have anything you like, or dislike about this app, please do send us some feedback and know that we will read it and either be happy with your positive response, or do the best we can to fix any errors, or things you suggest us to change. :) But DO feel free to review us on the app store! And please do!" as NSObject, RCKeys.requestReviewPeriod.rawValue: 40 as NSObject,
        "chanceOfReview": 0.2 as NSObject
    ])
    @Published var percentDone = 0.0
    @Published var images = [CGImage]()
    @Published var presentScanner = false
    @Published var isInAddFridgeItemView = false
    @Published var isInShoppingListItemAddingView = false
    @Published var isInStorageItemAddingView = false
    @Published var isInWhichView = WhichView.homeView
    
}
