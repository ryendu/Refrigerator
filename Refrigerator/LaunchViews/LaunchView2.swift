//
//  LaunchView4.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/29/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI
import CoreData
import Firebase

struct LaunchView2: View {
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var name = ""
    @State private var didFinishTyping = false
    @State var showNextView = false
    var body: some View {
        ZStack{
            Color.white
            .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("👋")
                    .font(.custom("Open Sans", size: CGFloat(60)))
                Text("Hey there, whats your name?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                TextField("name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                Spacer()
                
                Button(action: {
                    self.user[0].name = self.name
                    do{
                        try self.managedObjectContext.save()
                    }catch{
                        print(error)
                    }
                    self.showNextView.toggle()
                }, label: {Image("Next button")
                    .renderingMode(.original)}).padding(.bottom, CGFloat(60))
                Spacer()
                
            }
            if self.showNextView{
                LaunchView3()
            }
        }.onAppear{
            if self.user.count == 0 {
                let newUser = User(context: self.managedObjectContext)
                newUser.name = self.name
                newUser.dailyGoal = Int16(0)
                newUser.streak = Int16(0)
                do{
                    try self.managedObjectContext.save()
                }catch{
                    print(error)
                }
            }else if self.user.count == 1{
                self.name = self.user[0].name ?? ""
            }else {
                Analytics.logEvent("multipleUsersInCoredata", parameters: ["users": self.user.count])
                for indx in 0...self.user.count - 1{
                    if indx != 0 {
                        self.managedObjectContext.delete(self.user[indx])
                        try? self.managedObjectContext.save()
                    }
                }
            }
        }
    }
}
struct LaunchView2_Previews: PreviewProvider {
    
    static var previews: some View {
        LaunchView2()
    }
}
