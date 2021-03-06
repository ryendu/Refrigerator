//
//  DailyGoalCell.swift
//  Refrigerator
//
//  Created by Ryan Du on 7/15/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import SwiftUI

struct DailyGoalCell: View {
    @State var ringWidth: CGFloat = 200.0
    @State var geo: GeometryProxy
    @State var rotation = 0.0
    @State var goalStatus = 0
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var user: FetchedResults<User>
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color("whiteAndGray"))
                .cornerRadius(20)
                .shadow(color: Color("shadows"), radius: 4)
            VStack(alignment: .center){
                HStack{
                    Text("Daily Goal")
                        .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                }.padding()
                ZStack(alignment: .center){
                    PercentageRing(ringWidth: 17, percent: Double(calculatePercentByThirds(with: Double(self.goalStatus))), backgroundColor: Color.green.opacity(0.2), foregroundColors: [Color(hex: "5EFFC2"), Color(hex: "3BFF6B")])
                        .frame(width: ((self.geo.size.width - 130) / 2), height: ((self.geo.size.width - 130) / 2), alignment: .center)
                        .padding()
                        .rotationEffect(Angle(degrees: self.rotation))
                        .onTapGesture {
                            withAnimation(.interpolatingSpring(stiffness: 5, damping: 0.4)){
                                self.rotation += 45
                            }
                        }
                       
                    Text("\(self.goalStatus) / 3")
                        .multilineTextAlignment(.center)
                        .font(.custom("SFProDisplayMedium", size: 13))
                        .frame(width: ((self.geo.size.width - 130) / 2) - 30, height: ((self.geo.size.width - 130) / 2) - 30, alignment: .center)
                        .clipShape(Circle())
                }
                Text("Log or edit foods three times a day")
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .font(.custom("SFProDisplayThin", size: 13))
                    .padding()
                    
            }
            .onAppear{
                self.goalStatus = Int(self.user.first?.dailyGoal ?? 0)
            }
        .onReceive(NotificationCenter.default.publisher(for: .refreshDailyGoal)) {_ in

            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.refresh()
           }
        }
        }
    }
    func calculatePercentByThirds(with goal: Double) -> Double{
        return (goal / 3) * 100
    }
    func refresh() {
        withAnimation(.interpolatingSpring(stiffness: 4, damping: 1)){
            self.goalStatus = Int(self.user.first?.dailyGoal ?? 0)
        }
    }
}
 extension Notification.Name {

    static var refreshDailyGoal: Notification.Name {
        return Notification.Name("refreshDailyGoal")
    }
    static var refreshStreak: Notification.Name {
        return Notification.Name("refreshStreak")
    }
}


extension Double {
    func toRadians() -> Double {
        return self * Double.pi / 180
    }
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}

// https://liquidcoder.com/swiftui-ring-animation/
struct RingShape: Shape {
    // Helper function to convert percent values to angles in degrees
    static func percentToAngle(percent: Double, startAngle: Double) -> Double {
        (percent / 100 * 360) + startAngle
    }
    private var percent: Double
    private var startAngle: Double
    private let drawnClockwise: Bool
    
    // This allows animations to run smoothly for percent values
    var animatableData: Double {
        get {
            return percent
        }
        set {
            percent = newValue
        }
    }
    
    init(percent: Double = 100, startAngle: Double = -90, drawnClockwise: Bool = false) {
        self.percent = percent
        self.startAngle = startAngle
        self.drawnClockwise = drawnClockwise
    }
    
    // This draws a simple arc from the start angle to the end angle
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let radius = min(width, height) / 2
        let center = CGPoint(x: width / 2, y: height / 2)
        let endAngle = Angle(degrees: RingShape.percentToAngle(percent: self.percent, startAngle: self.startAngle))
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle), endAngle: endAngle, clockwise: drawnClockwise)
        }
    }
}

struct PercentageRing: View {
    
    private static let ShadowColor: Color = Color.black.opacity(0.2)
    private static let ShadowRadius: CGFloat = 5
    private static let ShadowOffsetMultiplier: CGFloat = ShadowRadius + 2
    
    private let ringWidth: CGFloat
    private let percent: Double
    private let backgroundColor: Color
    private let foregroundColors: [Color]
    private let startAngle: Double = -90
    private var gradientStartAngle: Double {
        self.percent >= 100 ? relativePercentageAngle - 360 : startAngle
    }
    private var absolutePercentageAngle: Double {
        RingShape.percentToAngle(percent: self.percent, startAngle: 0)
    }
    private var relativePercentageAngle: Double {
        // Take into account the startAngle
        absolutePercentageAngle + startAngle
    }
    private var firstGradientColor: Color {
        self.foregroundColors.first ?? .black
    }
    private var lastGradientColor: Color {
        self.foregroundColors.last ?? .black
    }
    private var ringGradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: self.foregroundColors),
            center: .center,
            startAngle: Angle(degrees: self.gradientStartAngle),
            endAngle: Angle(degrees: relativePercentageAngle)
        )
    }
    
    init(ringWidth: CGFloat, percent: Double, backgroundColor: Color, foregroundColors: [Color]) {
        self.ringWidth = ringWidth
        self.percent = percent
        self.backgroundColor = backgroundColor
        self.foregroundColors = foregroundColors
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background for the ring
                RingShape()
                    .stroke(style: StrokeStyle(lineWidth: self.ringWidth))
                    .fill(self.backgroundColor)
                    
                // Foreground
                RingShape(percent: self.percent, startAngle: self.startAngle)
                    .stroke(style: StrokeStyle(lineWidth: self.ringWidth, lineCap: .round))
                    .fill(self.ringGradient)
                // End of ring with drop shadow
                if self.getShowShadow(frame: geometry.size) {
                    Circle()
                        .fill(self.lastGradientColor)
                        .frame(width: self.ringWidth, height: self.ringWidth, alignment: .center)
                        .offset(x: self.getEndCircleLocation(frame: geometry.size).0,
                                y: self.getEndCircleLocation(frame: geometry.size).1)
                        .shadow(color: PercentageRing.ShadowColor,
                                radius: PercentageRing.ShadowRadius,
                                x: self.getEndCircleShadowOffset().0,
                                y: self.getEndCircleShadowOffset().1)
                }
            }
            
        }
        // Padding to ensure that the entire ring fits within the view size allocated
        .padding(self.ringWidth / 2)
    }
    
    private func getEndCircleLocation(frame: CGSize) -> (CGFloat, CGFloat) {
        // Get angle of the end circle with respect to the start angle
        let angleOfEndInRadians: Double = relativePercentageAngle.toRadians()
        let offsetRadius = min(frame.width, frame.height) / 2
        return (offsetRadius * cos(angleOfEndInRadians).toCGFloat(), offsetRadius * sin(angleOfEndInRadians).toCGFloat())
    }
    
    private func getEndCircleShadowOffset() -> (CGFloat, CGFloat) {
        let angleForOffset = absolutePercentageAngle + (self.startAngle + 90)
        let angleForOffsetInRadians = angleForOffset.toRadians()
        let relativeXOffset = cos(angleForOffsetInRadians)
        let relativeYOffset = sin(angleForOffsetInRadians)
        let xOffset = relativeXOffset.toCGFloat() * PercentageRing.ShadowOffsetMultiplier
        let yOffset = relativeYOffset.toCGFloat() * PercentageRing.ShadowOffsetMultiplier
        return (xOffset, yOffset)
    }
    
    private func getShowShadow(frame: CGSize) -> Bool {
        let circleRadius = min(frame.width, frame.height) / 2
        let remainingAngleInRadians = (360 - absolutePercentageAngle).toRadians().toCGFloat()
        if self.percent >= 100 {
            return true
        } else if circleRadius * remainingAngleInRadians <= self.ringWidth {
            return true
        }
        return false
    }
}

func refreshDailyGoalAndStreak(){
    NotificationCenter.default.post(name: .refreshDailyGoal, object: nil)
    NotificationCenter.default.post(name: .refreshStreak, object: nil)
}
