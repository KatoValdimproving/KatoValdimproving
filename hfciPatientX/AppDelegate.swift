//
//  AppDelegate.swift
//  hfciPatientX
//
//  Created by user on 13/09/21.
//

import UIKit
import UserNotifications
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //SettingsBundleHelper.shared.setInitialInfo()
        SettingsBundleHelper.shared.hospitalCode = "henryford"
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (succes, error) in
            if succes {
            print("notifications granted")
                self.configureUserNotifications()
            }
        }
               
        SettingsBundleHelper.shared.addObserverEnvoriment()
        asignBeaconToPainting()
        asignPaintingToBeacon()
        return true
    }
    
    func asignBeaconToPainting() {
        for (index, beacon) in beacons.enumerated() {
            beacon.location = paintings[index].location
            paintings[index].beacon = beacon
        }
    }
    
   
    func asignPaintingToBeacon() {
        for (index, beacon) in beacons.enumerated() {
            beacon.paintings.append(paintings[index])
        }
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
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    private func configureUserNotifications() {
      UNUserNotificationCenter.current().delegate = self
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.badge, .sound, .banner])
    }
}
