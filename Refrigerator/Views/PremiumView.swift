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
                        Text("Premium Subscription")
                            .font(.system(size: 32))
                            .fontWeight(.medium)
                            .padding()
                        Spacer()
                        Button(action: {
                            RefrigeratorProducts.store.restorePurchases()
                            print("Restoring Purchases")
                        },label: {
                            Text("Restore").padding()
                        })
                    }
                    
                    HStack{
                        Image(systemName: "checkmark")
                            .font(.system(size: 22))
                            .foregroundColor(.orange)
                            .padding()
                        Text("Be able to add foods from a food database with over 90k foods")
                            .font(.system(size: 22))
                            .padding()
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "checkmark")
                            .font(.system(size: 22))
                            .foregroundColor(.orange)
                            .padding()
                        Text("Be able to set custom food notifications times")
                            .font(.system(size: 22))
                            .padding()
                        Spacer()
                    }
                    Text("Note: setting a custom food notification time will apply to all foods")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
                    
                    HStack{
                        Image(systemName: "checkmark")
                            .font(.system(size: 22))
                            .foregroundColor(.orange)
                            .padding()
                        Text("Remove ads")
                            .font(.system(size: 22))
                            .padding()
                        Spacer()
                    }
                    
                    Image(systemName: "sparkles")
                        .foregroundColor(.orange)
                        .font(.system(size: 120))
                        .padding()
                    
                    if self.isPurchased == false{
                        Button(action: {
                            if let firstPrd = self.products.first{
                            RefrigeratorProducts.store.buyProduct(firstPrd)
                            }
                        }, label: {
                            Image("Subscribe Button").renderingMode(.original).padding()
                        })
                        
                    }else {
                        
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
                        },label: {
                            Image("ManageSubscriptionbutton").renderingMode(.original)
                            }).padding()
                    }
                    
                    Text("auto-renewing subscription")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding()
                    Text("\(self.refrigeratorViewModel.premiumPrice) per month")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding()
                }
                    
                HStack{
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://refrigerator.flycricket.io/terms.html")!)
                    }, label: {
                        Text("Terms And Conditions")
                    })
                    Text("and").padding()
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://refrigerator.flycricket.io/privacy.html")!)
                    }, label: {
                        Text("Privacy Policy")
                    })
                }
                
                .onReceive(NotificationCenter.default.publisher(for: .premiumPriceGot)) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        
                        self.refrigeratorViewModel.premiumPrice = self.products.first?.regularPrice ?? "$0.99"
                    
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
        }.navigationBarTitle(Text("Upgrade to Premium"))
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
