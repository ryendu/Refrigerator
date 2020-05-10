//
//  AboutDialougView.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/3/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct AboutDialougView: View {
    var body: some View {
        VStack {
            Text("About Dialoug")
                .font(.largeTitle)
            Spacer()
            
            Text("Refrigerator")
            Text("© 2020 Ryan Du.")
            Text("All rights reserved.")
            Text("Used icons by icons8")
            Text("https://icons8.com")
            Spacer()
        }
    }
}

struct AboutDialougView_Previews: PreviewProvider {
    static var previews: some View {
        AboutDialougView()
    }
}
