//
//  HomeView.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/28/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    //TODO: Change the funFact
    //TODO: make the addToShopping list in the viewmodel and have an instance of the viewmodels enviroment here
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @State var addToShoppingList = false
    @State var funFact = "chocolate is healthy"
    @State var refrigeItemsPreview = [refrigeItem(icon: "🥚", title: "eggs", daysLeft: 8),refrigeItem(icon: "🥑", title: "avocados", daysLeft: 5),refrigeItem(icon: "🍍", title: "pineapple", daysLeft: 1),refrigeItem(icon: "🍌", title: "Bananas", daysLeft: 1),refrigeItem(icon: "🍉", title: "watermellons", daysLeft: 4)]
    @State var funFoodFacts = ["did you know brocoli contains more protein than steak", "Chocolate is as healthy as a fruit"]
    //Shopping list will be diffrent than the refrigerator items because there may be things in the shopping list that may not be in the refrigerator items
    @State var shoppingList = [shoppingListItems(icon: "🥑", title: "avocados"), shoppingListItems(icon: "🥚", title: "eggs"), shoppingListItems(icon: "🥕", title: "carrots")]
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    ScrollView(.vertical, showsIndicators: true, content: {
                        VStack {
                            Text("Hi, Ryan")
                                .font(.custom("SF Compact Display", size: 38))
                //  TODO: Replace Hi, Ryan with the text below after done editiing
                //            Text("Hi, \(UserDefaults.standard.string(forKey: "name")!)") .font(.custom("SF Compact Display", size: 38))

                            Text(self.funFact)
                            .font(.custom("SF Pro Text", size: 16))
                            .foregroundColor(.black).font(.title).padding(15)
                            .background(Image("Rectangle").resizable().frame(width: geo.size.width - 18))
                                .padding()
                            
                            HStack{
                                Text("Eat These Foods Soon")
                                    .font(.custom("SF Compact Display", size: 23))
                                Spacer()
                                } .padding()
                            
                            ForEach(self.refrigeItemsPreview, id: \.self) { item in
                                RefrigeratorItemCell(icon: item.icon, title: item.title, lastsFor: item.daysLeft)
                            }
                            NavigationLink(destination: SeeMoreView(), label: {Text("see more").foregroundColor(.blue).multilineTextAlignment(.leading)})
                            

                            NavigationLink(destination: PremiumView(), label: {
                                Text("Upgrade Premium for just $4.99 a month")
                                    .font(.custom("SF Pro Text", size: 16))
                                    .foregroundColor(.black).font(.title).padding(15)
                                    .background(Image("Rectangle").resizable()
                                    .renderingMode(.original)
                                     .frame(width: geo.size.width - 18))
                                    .padding()
                            })
                            
                            
                            HStack{
                            Text("Shopping List")
                                .font(.custom("SF Compact Display", size: 23))
                            Spacer()
                                //TODO: Replace the following image with a button that lets you add an item to the shopping list
                                Button(action: {
                                    print("pressed add to shopping list button")
                                    self.refrigeratorViewModel.isInShoppingListItemAddingView.toggle()
                                }, label: {Image("plus")})
                            
                            } .padding()
                            
                            Text("Making a shopping list for your weekly grocery run helps prevent food waste and helps you eat healthier")
                                .foregroundColor(Color(hex: "878787"))
                            
                            ForEach(self.shoppingList) { item in

                                
                                ShoppingListCell(icon: item.icon, title: item.title)
                                

                            }
                            
                            NavigationLink(destination: AboutDialougView(), label: {
                                Text("about dialoug")
                            })
                            
                            
                        }
                    
                    })
                        .navigationBarBackButtonHidden(true)
                        
                    
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $refrigeratorViewModel.isInShoppingListItemAddingView, content: {AddToShoppingListSheet().environmentObject(refrigerator) })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(refrigerator)
    }
}
