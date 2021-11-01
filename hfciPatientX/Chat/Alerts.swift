//
//  Alerts.swift
//  NovaTrack
//
//  Created by Developer on 3/14/18.
//  Copyright © 2018 Paul Zieske. All rights reserved.
//
import UIKit

class Alerts {
    static func displayAlert(with title: String, and message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        //...
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        //...
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
//    static func displayAlertPainting(painting: Painting) {
//       
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let paintingBeaconViewcontroller = storyboard.instantiateViewController(withIdentifier: "PaintingBeaconViewController") as? PaintingBeaconViewController else { return }
//        //...
//        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
//        if let navigationController = rootViewController as? UINavigationController {
//            rootViewController = navigationController.viewControllers.first
//        }
//        if let tabBarController = rootViewController as? UITabBarController {
//            rootViewController = tabBarController.selectedViewController
//        }
//        //...
//        paintingBeaconViewcontroller.painting = painting
//        paintingBeaconViewcontroller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        paintingBeaconViewcontroller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        rootViewController?.present(paintingBeaconViewcontroller, animated: true, completion: nil)
//    }
    
    static func displayAlertWithCompletion(title: String, and message: String, completionHandler: @escaping () -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: completionHandler)
        }
        alertController.addAction(okAction)
        //...
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        //...
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    //create and present generic alert with send title and message
    static func alert(with root: UIViewController?, for message: String, with title: String) {
        if root != nil {
            root?.presentAlert(withTitle: title, message: message)
        } else {
            let topWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindow.Level.alert + 1
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.presentAlert(withTitle: title, message: message)
        }
    }

    //create and present alert for changing statuc at code scanning
    static func alertStatus() {
        
        let alert = UIAlertController(title: Constants.PANIC_ALERT_TITLE, message: Constants.PANIC_ALERT_MESSAGE, preferredStyle: UIAlertController.Style.alert)
        if let mAlerta = Constants.alertExpired{
            mAlerta.dismiss(animated: true, completion: nil)
            Constants.alertExpired = alert
        }
        alert.addAction(UIAlertAction(title: Constants.OK, style: .default, handler: { (action) in
                Constants.STATUS_CODE_VALUE = Constants.WPATIENT_CODE
            }))
        alert.addAction(UIAlertAction(title: Constants.CANCEL, style: .default, handler: nil))
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindow.Level.alert + 1
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //create and present alert when session has expired so the user will be out of the app
    static func alertSessionExpired() {
        //TODO: no llamar a main async
        DispatchQueue.main.async() {
           // PubNubManager.sharedInstance.stopLocationUpdates()
//            LocationManager.sharedInstance.stopLocationUpdates()
//            PubNubManager.sharedInstance.client?.unsubscribeFromAll(completion: { (PNStatus) in
//               
//            })
            
            let storyboard:UIStoryboard = UIStoryboard(name: Constants.STORYBOARD_NAME, bundle: nil)
                           let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                           let rootViewController = storyboard.instantiateViewController(withIdentifier: Constants.LOGINVC_NAME)  as! LoginViewController
                           navigationController.viewControllers = [rootViewController]
                           UIApplication.shared.keyWindow?.rootViewController = navigationController
                           UIApplication.shared.statusBarStyle = .lightContent

        }
    }
    
    static func getLocationServicesAuthStatusAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Important!", message: "Location Services authorization status should be set to 'Always' for NavvTrack to work correctly, please press Settings and update to 'Always'.", preferredStyle: .alert)
        let goSettings = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(goSettings)
        return alert
    }
    
    
}
