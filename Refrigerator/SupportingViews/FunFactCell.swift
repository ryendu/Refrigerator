//
//  FunFactCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/1/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct FunFactCell: View {
    @State var funFact: String
    @State var geo: GeometryProxy
    var body: some View {
                VStack{
                    Text(self.funFact)
                    .font(.custom("SF Pro Text", size: 16))
                    .padding()
                    
                }
                    .background(Rectangle().cornerRadius(16).padding(.horizontal)
                    .foregroundColor(Color("cellColor"))
                    .frame(width: geo.size.width)
                    )
                    .frame(width: geo.size.width - 42)
                    .padding(.bottom)
                    .fixedSize(horizontal: false, vertical: true)
        
    }
}



