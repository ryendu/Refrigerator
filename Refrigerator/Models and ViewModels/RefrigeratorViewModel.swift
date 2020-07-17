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
        "requestReview" : false as NSObject, RCKeys.feedbackViewMessage.rawValue: "Hey there! If you have anything you like, or dislike about this app, please do send us some feedback and know that we will read it and either be happy with your positive response, or do the best we can to fix any errors, or things you suggest us to change. :) But DO feel free to review us on the app store! And please do!" as NSObject, RCKeys.requestReviewPeriod.rawValue: 40 as NSObject])
    @Published var percentDone = 0.0
    @Published var images = [CGImage]()
    @Published var presentScanner = false
    @Published var isInAddFridgeItemView = false
    @Published var isInShoppingListItemAddingView = false
    @Published var isInStorageItemAddingView = false
    @Published var isInWhichView = WhichView.homeView
    @Published var trackDate = "07302020"
    // 1 2 3 0 2 0 2 0
    func getDate(from trackDate: String) -> Date? {
        let calendar = Calendar.current
        let digits = trackDate.digits
        var day = 0
        var month = 0
        var year = 0
        
        if digits[0] == 0 {
            month = digits[1]
        }else {
            month = 10 + digits[1]
        }
        
        if digits[2] == 0 {
            day = digits[3]
        } else if digits[2] == 1 {
            day = 10 + digits[3]
        } else if digits[2] == 2 {
            day = 20 + digits[3]
        } else if digits[2] == 3 {
            day = 30 + digits[3]
        }
        
        
        year = (digits[4] * 1000) + (digits[5] * 100) + (digits[6] * 10)
        if digits.count == 8 {
            year = year + digits[7]
        }
        print("digits: \(digits)")
        print(digits.count)
        print("day \(day)")
        print("month \(month)")
        print("year \(year)")
        let components = DateComponents(calendar: calendar, year: year, month: month, day: day)
        let date = calendar.date(from: components)
        return date
    }
    func getTrackDate (with date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let finalNumb = (String(format: "%02d%02d%02d", month, day, year))
        return finalNumb
    }
}

extension StringProtocol  {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}
extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension Numeric where Self: LosslessStringConvertible {
    var digits: [Int] { string.digits }
}
