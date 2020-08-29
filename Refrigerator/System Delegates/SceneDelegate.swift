//
//  SceneDelegate.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/28/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        var user: [User]? = nil
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
          user = try context.fetch(fetchRequest) as? [User]
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let launchView1 = LaunchView1().environment(\.managedObjectContext, context)
            let tabBarView = TabBarView().environment(\.managedObjectContext, context)
            
            if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
                if user?.first == nil{
                    print("THERE IS NO USER")
                    let newUser = User(context: context)
                    newUser.name = ""
                    newUser.dailyGoal = Int16(0)
                    newUser.streak = Int16(0)
                    newUser.foodsEaten = Int32(0)
                    newUser.foodsThrownAway = Int32(0)
                
                
                UserDefaults.standard.set(true, forKey: "didLaunchBefore")
                newUser.didReviewThisMonth = true

                let now = Calendar.current.dateComponents(in: .current, from: Date())
                let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + RemoteConfigManager.intValue(forkey: RCKeys.requestReviewPeriod.rawValue))
                let date = Calendar.current.date(from: tomorrow)
                let midnight = Calendar.current.startOfDay(for: date!)
                newUser.inAMonth = midnight
                let tomorrow1 = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
                let date1 = Calendar.current.date(from: tomorrow1)
                let midnight1 = Calendar.current.startOfDay(for: date1!)
                newUser.streakDueDate = midnight1
                newUser.midnightTomorrow = midnight1
                
                do{
                    try context.save()
                }catch{
                    print(error)
                }
                }
                window.rootViewController = UIHostingController(rootView: launchView1.environmentObject(refrigerator))
            } else {
                if UIDevice.current.userInterfaceIdiom == .phone{
                window.rootViewController = UIHostingController(rootView: tabBarView.environmentObject(refrigerator))
                }else if UIDevice.current.userInterfaceIdiom == .pad{
                    window.rootViewController = UIHostingController(rootView: IpadSidebarView().environmentObject(refrigerator).environment(\.managedObjectContext, context))
                }
            }
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

