//
//  AppDelegate.swift
//  Refrigerator
//
//  Created by Ryan Du on 4/28/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMobileAds
import UserNotifications
import AppLovinSDK
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        RemoteConfigManager.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        let sdk = ALSdk.shared(withKey: "uyPsJe0ovs7S7xTXrXDUzTuOvU_nQdwTgfIcQWPGXyd2W8QuqmRlrSa0C1ubG7kkSxhl7-NT3TEaIRgyvKfX3w")
        sdk?.initializeSdk()
        var user: [User]? = nil
        let managedContext =
            self.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
          user = try managedContext.fetch(fetchRequest) as? [User]
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
//        var expirationDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
//        if (expirationDate?.daysTo(date: Date()))! <= 1 {
//            UserDefaults.standard.removeObject(forKey: "recentlyDeleted")
//            print("cleared userDefaults")
//            
//            expirationDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
//        }
        if let usrs = user{
            if usrs.count > 0{
                let usr = usrs[0]
                if usr.inAMonth != nil{
                    if Date() > usr.inAMonth!{
                        
                        let now = Calendar.current.dateComponents(in: .current, from: Date())
                        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + RemoteConfigManager.intValue(forkey: RCKeys.requestReviewPeriod.rawValue))
                        let date = Calendar.current.date(from: tomorrow)
                        let midnight = Calendar.current.startOfDay(for: date!)
                        usr.inAMonth = midnight
                        usr.didReviewThisMonth = false
                        try? managedContext.save()
                    }
                }


                
                if usr.midnightTomorrow != nil{
                    if Date() > usr.midnightTomorrow! {
                        
                        let now = Calendar.current.dateComponents(in: .current, from: Date())
                        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1, hour: now.hour! + 6)
                        let date = Calendar.current.date(from: tomorrow)
                        let midnight = Calendar.current.startOfDay(for: date!)
                        usr.midnightTomorrow = midnight
                        usr.dailyGoal = 0
                        try? managedContext.save()
                        
                }
                }
                if usr.streakDueDate != nil{
                    if Date() > usr.streakDueDate! {
                        
                        let now = Calendar.current.dateComponents(in: .current, from: Date())
                        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1, hour: now.hour! + 6)
                        let date = Calendar.current.date(from: tomorrow)
                        let midnight = Calendar.current.startOfDay(for: date!)
                        usr.streakDueDate = midnight
                        usr.streak = 0
                        try? managedContext.save()
                }
                }
            }
            }else {
            print("user14 is nil app delegate")
        }
        UserDefaults.standard.set(false, forKey: "RefrigeratorViewLoadedAd")
        UserDefaults.standard.set(false, forKey: "IndivisualRefrigeratorViewLoadedAd")
        UserDefaults.standard.set(false, forKey: "ExamineRecieptViewLoadedAd")
        UserDefaults.standard.set(false, forKey: "SeeMoreViewLoadedAd")
        
        let pushManager = PushNotificationManager(userID: "currently_logged_in_user_id")
        pushManager.registerForPushNotifications()
         
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func saveContext () {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Refrigerator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let userID: String
    init(userID: String) {
        self.userID = userID
        super.init()
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            let usersRef = Firestore.firestore().collection("users_table").document(userID)
            usersRef.setData(["fcmToken": token], merge: true)
        }
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        updateFirestorePushTokenIfNeeded()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
}
