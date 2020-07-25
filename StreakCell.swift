//
//  StreakCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/16/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct StreakCell: View {
    @State var geo: GeometryProxy
    @State var streak = 0
    @State var rotation = 0.0
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    @Environment(\.managedObjectContext) var managedObjectContext
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color("whiteAndGray"))
                .cornerRadius(20)
                .shadow(color: Color("shadows"), radius: 4)
            VStack(alignment: .center){
                HStack{
                    Text("Streak")
                        .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                }.padding(.vertical)
                Spacer()
                ZStack(alignment: .center){
                    PercentageRing(ringWidth: 17, percent: Double(100 + (self.streak * 10)), backgroundColor: Color.orange.opacity(0.2), foregroundColors: [Color(hex: "FF0000"), Color(hex: "FF3A3A"), Color(hex: "FF6E38")])
                        .frame(width: ((self.geo.size.width - 130) / 2), height: ((self.geo.size.width - 130) / 2), alignment: .center)
                        .padding()
                        .rotationEffect(Angle(degrees: self.rotation))
                        .onTapGesture {
                            simpleSuccess()
                            withAnimation(.interpolatingSpring(stiffness: 5, damping: 0.4)){
                                self.rotation += 45
                            }
                        }
                    Text("\(self.streak) Day 🔥")
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.center)
                        .font(.custom("SFProDisplayMedium", size: 19))
                        .frame(width: ((self.geo.size.width - 130) / 2) - 30, height: ((self.geo.size.width - 130) / 2) - 30, alignment: .center)
                        .clipShape(Circle())
                }
                  Text("Achieve your daily goal to earn a streak")
                    .multilineTextAlignment(.center)
                    .font(.custom("SFProDisplayThin", size: 13))
                    .padding()
            }
            .onAppear{
                self.streak = Int(self.user[0].streak)
            }
            .onReceive(NotificationCenter.default.publisher(for: .refreshStreak)) {_ in

                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.interpolatingSpring(stiffness: 4, damping: 1)){
                        self.streak = Int(self.user[0].streak)
                    }
               }
            }
        }
        
    }
}
