//
//  LaunchView.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import ConcentricOnboarding

struct LaunchView1: View {
    @State var showNextView = false
    var body: some View {
        //[Color(hex: "6A63FF"), Color(hex: "C463FF"), Color(hex: "4AD0FF")]
        var onboarding =  ConcentricOnboardingView(pages: [AnyView(LaunchPageView1()), AnyView(LaunchView2()), AnyView(LaunchView3()),AnyView(LaunchView4()),AnyView(LaunchView405()),AnyView(LaunchView5())], bgColors: [Color(hex: "FFE5A1"), Color(hex: "FFACAC"), Color(hex: "B9FFAC"),Color(hex: "8DFFF2"), Color(hex: "FFE5A1"), Color(hex: "B9FFAC"),Color(hex: "FFACAC")])
        onboarding.insteadOfCyclingToFirstPage = {
            withTransaction(.init(animation: .default)){
                self.showNextView = true
            }
        }
        
        return ZStack{
            if self.showNextView{
                Color("whiteAndBlack").edgesIgnoringSafeArea(.all)
            }
            onboarding
            
            if self.showNextView {
                TabBarView().transition(.slide)
            }
        }
    }
}

struct LaunchPageView1: View {
    @State var animationAmount:CGSize = CGSize(width: 0, height: 0)
    var body: some View {
        ZStack{
            GeometryReader{ geo in
                    VStack {
                        Text("Hey there, welcome to the Refrigerator App!")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.top, CGFloat())
                            .padding(.horizontal, CGFloat(20))
                        
                        
                        
                    }
                
            }
            
        }
        
        
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
