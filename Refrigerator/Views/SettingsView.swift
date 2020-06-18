//
//  SettingsView.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/2/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//
import SwiftUICharts
import Combine
import SwiftUI
import GoogleMobileAds

struct SettingsView: View{
    func possiblyDoSomething(withPercentAsDecimal percent: Double) -> Bool{
        func simplify(top:Int, bottom:Int) -> (newTop:Int, newBottom:Int) {

            var x = top
            var y = bottom
            while (y != 0) {
                let buffer = y
                y = x % y
                x = buffer
            }
            let hcfVal = x
            let newTopVal = top/hcfVal
            let newBottomVal = bottom/hcfVal
            return(newTopVal, newBottomVal)
        }
        let denomenator = simplify(top:Int(percent * 100), bottom: 100)
        var returnValue = false
        print(denomenator)
        if Int.random(in: 1...denomenator.newBottom) == 1 {
        returnValue = true
      }
       return returnValue
    }

    @State var name = UserDefaults.standard.string(forKey: "name") ?? ""
    var body: some View{
        NavigationView{
            GeometryReader{ geo in
                List{
                    Section{
                   Text("Name")
                    .font(.title)
                        HStack{
                            TextField("name", text: self.$name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                UserDefaults.standard.set(self.name, forKey: "name")
                            }, label: {
                                Text("Save")
                                })
                        }
                    }
                    
                    Section{
                        Text("Progress")
                        .font(.title)
                    NavigationLink(destination: ProgressView(), label: {
                        Text("See Your Progress")
                    })
                     }
                    Section{
                    NavigationLink(destination: AboutDialougView(), label: {
                        Text("about dialoug")
                    })
                     }
                    Section{
                        if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 2 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)){
                        GADBannerViewController()
                        .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                        }else {

                        }
                        
                    }
                    
                    Section{
                    NavigationLink(destination: FeedbackView(), label: {
                        Text("send feedback")
                    })
                     }
                    }.listStyle(GroupedListStyle())
                
            .navigationBarTitle("Settings")
            
            
        }
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}
struct ProgressView: View {
    func possiblyDoSomething(withPercentAsDecimal percent: Double) -> Bool{
        func simplify(top:Int, bottom:Int) -> (newTop:Int, newBottom:Int) {

            var x = top
            var y = bottom
            while (y != 0) {
                let buffer = y
                y = x % y
                x = buffer
            }
            let hcfVal = x
            let newTopVal = top/hcfVal
            let newBottomVal = bottom/hcfVal
            return(newTopVal, newBottomVal)
        }
        let denomenator = simplify(top:Int(percent * 100), bottom: 100)
        var returnValue = false
        print(denomenator)
        if Int.random(in: 1...denomenator.newBottom) == 1 {
        returnValue = true
      }
       return returnValue
    }
    let pieChartStyle = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Colors.GradientNeonBlue,
        secondGradientColor: Colors.GradientPurple,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    @State var thrownAway = UserDefaults.standard.double(forKey: "thrownAway")
    @State var eaten = UserDefaults.standard.double(forKey: "eaten")


    @State var foodsThrownAwayInThePastWeek: [shoppingListItems]? = nil
    @State var lineChartWidth = Double()
    var body: some View {
            
                    GeometryReader { i in
                     List{
                        
                        VStack{
                            
                            Text("Here Is Your Progress")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding()
                            PieChartView(data: [self.eaten,self.thrownAway], title: "Foods Eaten Vs Thrown Away", legend: "Legendary", style: self.pieChartStyle, form: CGSize(width:self.lineChartWidth, height:self.lineChartWidth), dropShadow: false).padding()
                                Text("You Have thrown away \(Int(UserDefaults.standard.double(forKey: "thrownAway"))) Items Since Using this app.")
                            
                            
                            if self.foodsThrownAwayInThePastWeek != nil{
                                Text("Foods You Threw away Today")
                                .font(.custom("SF Compact Display", size: 22))
                                .fontWeight(.semibold)
                                ScrollView(.vertical, showsIndicators: true, content: {
                                    ForEach(self.foodsThrownAwayInThePastWeek!, id: \.self){ item in
                                        
                                        
                                        HStack {
                                            HStack {
                                                Text(item.icon)
                                                    .font(.largeTitle)
                                                    .padding(.leading, 8)
                                                VStack {
                                                    HStack {
                                                        Text(item.title)
                                                            .font(.custom("SF Pro Text", size: 16))
                                                            .multilineTextAlignment(.leading)
                                                        Spacer()
                                                    }
                                                    
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                            .background(Rectangle().cornerRadius(16).padding(.horizontal)
                                            .foregroundColor(Color("cellColor"))
                                            )
                                                .padding(.bottom)
                                        }
                                        
                                        
                                        
                                        
                                    }
                                })
                            
                            }else {
                                Text("You have thrown away no food in the past day")
                            }
                                }.onAppear(perform: {
                                self.lineChartWidth = Double(i.size.width - 50)
                                self.thrownAway = UserDefaults.standard.double(forKey: "thrownAway")
                                self.eaten = UserDefaults.standard.double(forKey: "eaten")
                                
                                if let data = UserDefaults.standard.data(forKey: "recentlyDeleted") {
                                    do {
                                        // Create JSON Decoder
                                        let decoder = JSONDecoder()

                                        // Decode Note
                                        let note = try decoder.decode([shoppingListItems].self, from: data)
                                        self.foodsThrownAwayInThePastWeek = note
                                    } catch {
                                        print("Unable to Decode Note (\(error))")
                                    }
                                }
                        })
                    
                    
                    
                    
                    if RemoteConfigManager.intValue(forkey: RCKeys.numberOfAdsNonHomeView.rawValue) >= 1 && self.possiblyDoSomething(withPercentAsDecimal: RemoteConfigManager.doubleValue(forkey: RCKeys.chanceOfBanners.rawValue)){
                    GADBannerViewController()
                    .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
                    }else {

                    }
                    
                }

                
            
            }
            
                    

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
