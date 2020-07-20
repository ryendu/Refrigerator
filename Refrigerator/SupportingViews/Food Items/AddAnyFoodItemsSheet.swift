//
//  AddAnyFoodItemsSheet.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/19/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct AddAnyFoodItemsSheet: View {
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: AddFoodItemsListView(), label: {
                    Image("SelectFromListButton").renderingMode(.original)
                    }).padding()
//                NavigationLink(destination: AddFoodItemSheet(), label: {
//                Image("EnterManuallyButton").renderingMode(.original)
//                }).padding()
                //TODO: add more options
            }
        }
    }
}

struct AddAnyFoodItemsSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddAnyFoodItemsSheet()
    }
}
