//
//  LaunchView3.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView4: View {
    @Binding var showNextView: Bool
    var body: some View {
        return ZStack{ Color(hex: "FFE5A1").edgesIgnoringSafeArea(.all)
            VStack {
                        
                    Spacer()
                        Image(systemName: "doc.text.viewfinder")
                            .font(.system(size: 50))
                            .foregroundColor(.black)
                            .padding()
                        Text("Scan reciepts and have foods be automatically added to your storage locations.")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, CGFloat())
                        .padding(.horizontal, CGFloat(20))
                        Spacer()
                       NavigationLink(destination: LaunchView5(showNextView: self.$showNextView), label: {
                           Image("Next button").renderingMode(.original).padding()
                       })
                }
        }
    }
}

struct LaunchView405: View {

    var body: some View {
        return ZStack{
            Color(hex: "8DFFF2").edgesIgnoringSafeArea(.all)
            VStack {
                    
                    Spacer()
                HStack{
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundColor(.black)
                            .padding()
                    Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundColor(.black)
                    .padding()
                    Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundColor(.black)
                    .padding()
                }
                    Text("Plan for the future with the food planner.")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, CGFloat())
                    .padding(.horizontal, CGFloat(20))
                    HStack{
                            Image(systemName: "sparkles")
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                                .padding()
                        Image(systemName: "sparkles")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                        .padding()
                        Image(systemName: "sparkles")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                        .padding()
                    }
                    
                Spacer()
            }
        }
    }
}
