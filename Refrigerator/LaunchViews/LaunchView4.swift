//
//  LaunchView3.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct LaunchView4: View {

    var body: some View {
        ZStack{
                VStack {
                        
                        Spacer()
                            Image(systemName: "doc.text.viewfinder")
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                                .padding()
                        Text("Scan reciepts and have foods to be automatically added to your storage locations.")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, CGFloat())
                        .padding(.horizontal, CGFloat(20))
                        
                       
                    Spacer()
                }
           
        }
    }
}

struct LaunchView405: View {

    var body: some View {
        ZStack{
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

struct LaunchView4_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView4()
    }
}
