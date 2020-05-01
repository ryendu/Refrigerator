//
//  LaunchView.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView1: View {
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Hey there, welcome to the Refrigerator App!")
                    .font(.custom("SF Compact Display", size: 35))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.top, CGFloat())
                .padding(.horizontal, CGFloat(20))
                Spacer()
                Text("The average american throws away 250 pounds of food each Year.")
                    .multilineTextAlignment(.center)
                    .font(.custom("SF Compact Display", size: 27))
                    .foregroundColor(Color(hex: "3D3D3D"))
                    .padding(.horizontal, CGFloat(20))
                    .padding(.bottom, CGFloat(35))
                Text("lets change that with the refrigerator app!")
                .multilineTextAlignment(.center)
                .font(.custom("SF Compact Display", size: 27))
                .foregroundColor(Color(hex: "3D3D3D"))
                    .padding(.horizontal, CGFloat(20))
                .padding(.bottom, CGFloat(35))

                Text("The following  pages will be an intro to the main features of Refrigerator")
                .multilineTextAlignment(.center)
                .font(.custom("SF Compact Display", size: 27))
                .foregroundColor(Color(hex: "3D3D3D"))
                .padding(.horizontal, CGFloat(20))
                .padding(.bottom, CGFloat(35))

                Spacer()
                
                NavigationLink(destination: LaunchView2(), label: {
                    Image("Next button")
                        .renderingMode(.original)
                })
                    .padding(.bottom, CGFloat(60))
                
            }
        }
        
        
    }
}

struct LaunchView1_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView1()
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
