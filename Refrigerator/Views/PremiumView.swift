//
//  PremiumView.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/23/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import StoreKit

struct PremiumView: View {
    @State var products: [SKProduct] = []
    @State var isPurchased = false
    @EnvironmentObject var refrigeratorViewModel: RefrigeratorViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            
            ScrollView{
                VStack{
                    Divider().padding()
                    
                    
                    HStack{
                        Image(systemName: "checkmark")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                            .padding(.horizontal)
                        Text("Be able to add foods from a food database with over 90k foods")
                            .font(.system(size: 18))
                            .padding(.horizontal)
                        Spacer()
                    }.padding()
                    
                    HStack{
                        Image(systemName: "checkmark")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                            .padding(.horizontal)
                        Text("Be able to set custom food notifications times")
                            .font(.system(size: 18))
                            .padding(.horizontal)
                        Spacer()
                    }.padding()
//                    Text("Note: setting a custom food notification time will apply to all foods")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .padding()
                    
                    HStack{
                        Image(systemName: "checkmark")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                            .padding(.horizontal)
                        Text("Remove ads")
                            .font(.system(size: 18))
                            .padding(.horizontal)
                        Spacer()
                    }.padding()
                    
//                    Image(systemName: "sparkles")
//                        .foregroundColor(.orange)
//                        .font(.system(size: 100))
//                        .padding()
                    
                    if self.isPurchased == false{
                        Button(action: {
                            if let firstPrd = self.products.first{
                            RefrigeratorProducts.store.buyProduct(firstPrd)
                            }
                        }, label: {
                            SubscribeButton(text: "\(self.refrigeratorViewModel.premiumPrice) per month").padding()
                            
                        }).padding(.top, 65)
                        
                    }else {
                        
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
                        },label: {
                            Image("ManageSubscriptionbutton").renderingMode(.original)
                            }).padding()
                    }
                    Text("7 day free trial if eligible")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .padding(.horizontal).padding(.bottom)
                    Text("auto-renewing subscription")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                }
                    
                HStack{
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://refrigerator.flycricket.io/terms.html")!)
                    }, label: {
                        Text("Terms And Conditions").font(.system(size: 15))
                    }).padding(.leading)
                    Text("and").font(.system(size: 15)).padding()
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://refrigerator.flycricket.io/privacy.html")!)
                    }, label: {
                        Text("Privacy Policy").font(.system(size: 15))
                    }).padding(.trailing)
                }
                
                .onReceive(NotificationCenter.default.publisher(for: .premiumPriceGot)) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        
                        self.refrigeratorViewModel.premiumPrice = self.products.first?.regularPrice ?? "$1.99"
                    
                    }
                }
                
            }
            
                .onAppear{
                
                print("is product purchased: \(RefrigeratorProducts.store.isProductPurchased("com.ryandu.refrigerators.premiumsubscriptionm"))")
                if RefrigeratorProducts.store.isProductPurchased("com.ryandu.refrigerators.premiumsubscriptionm"){
                    self.isPurchased = true
                }else {
                    self.isPurchased = false
                }
                    print("on appear")
                RefrigeratorProducts.store.requestProducts{ success, products in
                    
                    if success {
                        if let producs = products{
                        self.products = producs
                            print("Products found: \(String(describing: self.products.first?.productIdentifier))")
                        }else {
                            print("Didnt find products")
                        }
                        
                        
                    }else {
                        print("error getting products")
                    }
                }
                
            }
        }.navigationBarTitle(Text("Premium Subscription"))
        .navigationBarItems(trailing: Button(action: {
            RefrigeratorProducts.store.restorePurchases()
            print("Restoring Purchases")
        },label: {
            Text("Restore").padding()
        }))
        .onReceive(NotificationCenter.default.publisher(for: .purchased)) {_ in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.isPurchased = true
            }
        }

        
    }
}

extension Float {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}

struct SubscribeButton: View {
    @State var text: String
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text(text)
                    .foregroundColor(.white)
                    .font(.custom("SFProDisplay-Bold", size: 22))
                Spacer()
            }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "FF8838"), Color(hex: "FF5839")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 57)
                        .padding()
                )
                
            
        }
    }
}
