//
//  AddFoodItemsListView.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/19/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct AddFoodItemsListView: View {
    let apiKey = "712bb6d76298489d8ec1490824e4184a"
    let basicSearchURL = "https://api.spoonacular.com/food/products/search?query="
    @State var searchText = ""
    @State var autoCompleteResults: [AutoCompleteObject] = []
    @State var searchResults: [SearchDisplayObject] = []
    @State var showAddList = false
    var body: some View {
        GeometryReader{ geo in
            VStack{
                ScrollView{
                    VStack{
                        SearchBar(text: self.$searchText, autocomplete: {
                            self.searchResults.removeAll()
                            self.autoCompleteResults.removeAll()
                            print(self.searchText)
                            if let url = URL(string: "https://api.spoonacular.com/food/products/suggest?query=\(self.searchText)&number=7&apiKey=712bb6d76298489d8ec1490824e4184a"){
                            let task = URLSession.shared.dataTask(with: url, completionHandler: {dataa, response, error in
                                if let err = error{
                                    print(err.localizedDescription)
                                    return
                                }
                                if let data = dataa, let results = try? JSONDecoder().decode(AutoCompleteResult.self, from: data){
                                    print("got search results: \(results.results)")
                                    self.autoCompleteResults = results.results
                                }
                            })
                                task.resume()
                        }
                            
                        }, searching: {
                            print("starting search")
                            self.searchResults.removeAll()
                            self.autoCompleteResults.removeAll()
                            print(self.searchText)
                            let searchPrompt = self.searchText.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                            if let url = URL(string: "https://api.spoonacular.com/food/products/search?query=\(searchPrompt)&number=3&apiKey=712bb6d76298489d8ec1490824e4184a"){
                                let task = URLSession.shared.dataTask(with: url, completionHandler: {dataa, response, error in
                                    if let err = error{
                                        print(err.localizedDescription)
                                        return
                                    }
                                    if let data = dataa, let results = try? JSONDecoder().decode(SearchResult.self, from: data){
                                        print("got search results: \(results.products)")
                                        for product in results.products{
                                            if let url = URL(string: product.image){
                                                DispatchQueue.global().async {
                                                    if let data = try? Data(contentsOf: url) {
                                                        if let image = UIImage(data: data) {
                                                            DispatchQueue.main.async {
                                                                let newObj = SearchDisplayObject(id: product.id, title: product.title, image: image)
                                                                self.searchResults.append(newObj)
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                })
                                task.resume()
                            }
                        })
                        if self.autoCompleteResults.count > 0 {
                            ForEach(self.autoCompleteResults, id: \.self){result in
                                Button(action: {
                                    self.searchResults.removeAll()
                                    self.autoCompleteResults.removeAll()
                                    self.searchText = result.title
                                    print("starting search")
                                    print(self.searchText)
                                    let searchPrompt = self.searchText.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                                    if let url = URL(string: "https://api.spoonacular.com/food/products/search?query=\(searchPrompt)&number=3&apiKey=712bb6d76298489d8ec1490824e4184a"){
                                        let task = URLSession.shared.dataTask(with: url, completionHandler: {dataa, response, error in
                                            if let err = error{
                                                print(err.localizedDescription)
                                                return
                                            }
                                            if let data = dataa, let results = try? JSONDecoder().decode(SearchResult.self, from: data){
                                                print("got search results: \(results.products)")
                                                for product in results.products{
                                                    if let url = URL(string: product.image){
                                                    DispatchQueue.global().async {
                                                        if let data = try? Data(contentsOf: url) {
                                                            if let image = UIImage(data: data) {
                                                                DispatchQueue.main.async {
                                                                    let newObj = SearchDisplayObject(id: product.id, title: product.title, image: image)
                                                                    self.searchResults.append(newObj)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                                }
                                            }
                                        })
                                        task.resume()
                                    }
                                }, label: {
                                    AutoCompleteResultsCell(text: result.title, geo: geo)
                                }).buttonStyle(PlainButtonStyle())
                                
                                
                            }
                        }
                        
                        ForEach(self.searchResults, id:\.self){result in
                            SearchResultsCell(text: result.title, image: Image(uiImage: result.image), geo: geo)
                        }
                    }.navigationBarTitle(Text("Search For Foods"))
                }
                //Add Foods Button
            }
        }
    }
}

struct SearchResult: Codable{
    var products: [SearchObject]
    var totalProducts: Int
    var type: String
    var offset: Int
    var number: Int
}
struct SearchObject: Hashable, Codable{
    var id: Int
    var title: String
    var image: String
    var imageType: String
}
struct SearchDisplayObject: Hashable{
    var id: Int
    var title: String
    var image: UIImage
}
struct AutoCompleteResult: Codable{
    var results: [AutoCompleteObject]
}
struct AutoCompleteObject: Codable, Hashable {
    var id: Int
    var title: String
}
struct AutoCompleteResultsCell:View {
    @State var text: String
    @State var geo: GeometryProxy
    var body: some View{
        Text(self.text)
        .padding()
            .background(Rectangle().padding(.horizontal)
                .foregroundColor(Color("cellColor"))
                .frame(width: geo.size.width)
        )   .frame(width: geo.size.width - 42)
            .fixedSize(horizontal: false, vertical: true)
    }
}
struct SearchResultsCell:View {
    @State var text: String
    @State var image: Image?
    @State var geo: GeometryProxy
    var body: some View{
        HStack{
            if self.image != nil{
                self.image!
                .resizable()
                    .frame(width:60,height:60,alignment: .leading)
            }
        Text(self.text)
            
        }
        .padding()
        
            .background(Rectangle().padding(.horizontal)
                .foregroundColor(Color("whiteAndGray"))
                .frame(width: geo.size.width).cornerRadius(12)
            ).padding()
            .shadow(color: Color("shadows"), radius: 4)
            .frame(width: geo.size.width - 42)
            .padding(.bottom)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    var autocomplete: ()->Void
    var searching: ()->Void
    
    var body: some View {
        let binding = Binding<String>(get: {
            self.text
        }, set: {
            self.text = $0
            print("search text: \(self.text)")
            self.autocomplete()
            // do whatever you want here
        })
        
        return HStack {
            
            TextField("Search ...", text: binding, onCommit: {self.searching()})
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
            }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
            Button(action: {
                self.isEditing = false
                self.searching()
            }) {
                Text("Search")
            }
            .padding(.trailing, 10)
            .transition(.move(edge: .trailing))
            .animation(.default)
        }
    }
}
