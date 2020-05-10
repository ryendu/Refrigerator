//
//  AddToShoppingListSheet.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/3/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//


import SwiftUI
struct emoji: Identifiable, Hashable{
    var id = UUID()
    var emoji: String
}

struct AddToShoppingListSheet: View {
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @State var selectedEmoji = ""
    @State var listOfEmojis1 = [emoji(emoji: "🍏"), emoji(emoji: "🍎"), emoji(emoji: "🍐"),emoji(emoji: "🍊"),emoji(emoji: "🍋"),emoji(emoji: "🍌"),emoji(emoji: "🍉"),emoji(emoji: "🍇"),emoji(emoji: "🍓"),emoji(emoji: "🍈"),emoji(emoji: "🍒"),emoji(emoji: "🍑"),emoji(emoji: "🥭"),emoji(emoji: "🍍"),emoji(emoji: "🥥"),emoji(emoji: "🥝"),emoji(emoji: "🍅"),emoji(emoji: "🍆"),emoji(emoji: "🥑"),emoji(emoji: "🥦"),emoji(emoji: "🥬"),emoji(emoji: "🥒"),emoji(emoji: "🌶"),emoji(emoji: "🌽"),emoji(emoji: "🥕"),emoji(emoji: "🧄"),emoji(emoji: "🥔"),emoji(emoji: "🍠"),emoji(emoji: "🥐"),emoji(emoji: "🥯"),emoji(emoji: "🍞"),emoji(emoji: "🥖"),emoji(emoji: "🥨"),emoji(emoji: "🧀"),emoji(emoji: "🥚")]
    
    @State var listOfEmojis2 = [emoji(emoji: "🍳"),emoji(emoji: "🧈"),emoji(emoji: "🥞"),emoji(emoji: "🧇"),emoji(emoji: "🥓"),emoji(emoji: "🥩"),emoji(emoji: "🍗"),emoji(emoji: "🍖"),emoji(emoji: "🦴"),emoji(emoji: "🌭"),emoji(emoji: "🍔"),emoji(emoji: "🍟"),emoji(emoji: "🍕"),emoji(emoji: "🥪"),emoji(emoji: "🥙"),emoji(emoji: "🧆"),emoji(emoji: "🌮"),emoji(emoji: "🌯"),emoji(emoji: "🥗"),emoji(emoji: "🥘"),emoji(emoji: "🥫"),emoji(emoji: "🍝"),emoji(emoji: "🍜"),emoji(emoji: "🍲"),emoji(emoji: "🍛"),emoji(emoji: "🍣"),emoji(emoji: "🍱"),emoji(emoji: "🥟"),emoji(emoji: "🍙"),emoji(emoji: "🍚"),emoji(emoji: "🍘"),emoji(emoji: "🍥"),emoji(emoji: "🥠"),emoji(emoji: "🥮"),emoji(emoji: "🍢")]
    
    @State var listOfEmojis3 = [emoji(emoji: "🍡"),emoji(emoji: "🍧"),emoji(emoji: "🍨"),emoji(emoji: "🍦"),emoji(emoji: "🥧"),emoji(emoji: "🧁"),emoji(emoji: "🍰"),emoji(emoji: "🎂"),emoji(emoji: "🍮"),emoji(emoji: "🍭"),emoji(emoji: "🍬"),emoji(emoji: "🍫"),emoji(emoji: "🍿"),emoji(emoji: "🍩"),emoji(emoji: "🍪"),emoji(emoji: "🌰"),emoji(emoji: "🥜"),emoji(emoji: "🍯"),emoji(emoji: "🥛"),emoji(emoji: "🍼"),emoji(emoji: "☕️"),emoji(emoji: "🍵"),emoji(emoji: "🧃"),emoji(emoji: "🥤"),emoji(emoji: "🍶"),emoji(emoji: "🍺"),emoji(emoji: "🍻"),emoji(emoji: "🥂"),emoji(emoji: "🍷"),emoji(emoji: "🥃"),emoji(emoji: "🍸"),emoji(emoji: "🍹"),emoji(emoji: "🧉"),emoji(emoji: "🍾"),emoji(emoji: "🧊")]
        
        
    
    @State var nameOfFood = ""
    var body: some View {
        VStack {
            Text("Add Item To Shopping List")
                .font(.largeTitle)
                .layoutPriority(1)
            HStack {
                Text("Whats the name of this food")
                    .multilineTextAlignment(.leading)
                Spacer()
            }.padding(.horizontal)
                
            TextField("name of Food item", text: $nameOfFood)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 40)
            
            HStack {
                Text("chose an emoji for this food")
                Spacer()
            }.padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: true, content: {
                VStack {
                    HStack{
                    ForEach(listOfEmojis1, id: \.self) {emoji in
                        
                        Button(action: {self.selectedEmoji = emoji.emoji}, label:{
                            if self.selectedEmoji == emoji.emoji{
                                Text(emoji.emoji)
                                    .background(Image("Rectangle")
                                        .resizable()
                                        .renderingMode(.original)
                                )
                                
                            }else {
                                Text(emoji.emoji)
                            }
                        })
                    }
                    }.padding()
                    HStack{
                    ForEach(listOfEmojis2, id: \.self) {emoji in
                        
                        Button(action: {self.selectedEmoji = emoji.emoji}, label:{
                            if self.selectedEmoji == emoji.emoji{
                                Text(emoji.emoji)
                                    .background(Image("Rectangle")
                                        .resizable()
                                        .renderingMode(.original)
                                )
                                
                            }else {
                                Text(emoji.emoji)
                            }
                        })
                    }
                    }.padding()
                    HStack{
                    ForEach(listOfEmojis3, id: \.self) {emoji in
                        
                        Button(action: {self.selectedEmoji = emoji.emoji}, label:{
                            if self.selectedEmoji == emoji.emoji{
                                Text(emoji.emoji)
                                    .background(Image("Rectangle")
                                        .resizable()
                                        .renderingMode(.original)
                                )
                                
                            }else {
                                Text(emoji.emoji)
                            }
                        })
                    }
                    }.padding()
                }

            })
            
            Button(action: {
                self.refrigeratorViewModel.isInShoppingListItemAddingView.toggle()
                //TODO: add to CoreData Shopping List
            }, label: {Image("add").renderingMode(.original)})
        }
        
    }
    
}

var refrigerator = RefrigeratorViewModel()
struct AddToShoppingListSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddToShoppingListSheet().environmentObject(refrigerator)
    }
}
