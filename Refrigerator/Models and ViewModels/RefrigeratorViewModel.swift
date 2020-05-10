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

class RefrigeratorViewModel: ObservableObject {
    
    @Published var isInAddFridgeItemView = false
    @Published var isInShoppingListItemAddingView = false
    @Published var isInStorageItemAddingView = false
    @Published var isInWhichView = WhichView.homeView
}
