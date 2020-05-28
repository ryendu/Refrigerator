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
    var body: some View {
                Text(self.funFact)
                    .font(.custom("SF Pro Text", size: 16))
                    .padding()
                    .background(Rectangle().cornerRadius(16).padding(.horizontal)
                    .foregroundColor(Color("cellColor")))
                    .padding(.bottom)
    }
}


struct FunFactCell_Previews: PreviewProvider {
    static var previews: some View {
        FunFactCell(funFact: "Brocolie has more protein than steak like a lot more protein than steak oh my god.")
    }
}


