//
//  Extensions.swift
//  NovaTrack
//
//  Created by Developer on 1/18/18.
//  Copyright © 2018 Paul Zieske. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftySound
import MapKit

let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,6}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func isEmail() -> Bool {
        return self.text!.isEmail()
    }
    
}
//add some seconds to show notification
extension Date {
    
    var relativelyFormatted:String {

        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: now)

        if let months = components.month, months > 0  {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: self)
        }

        if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        }

        if let days = components.day, days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        }

        if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        }

        if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        }

        if let seconds = components.second, seconds > 30 {
            return "\(seconds) second\(seconds == 1 ? "" : "s") ago"
        }

        return "Just now"
    }
    
    func addedBy(seconds:Int) -> Date {
        return Calendar.current
            .date(byAdding: .second, value: seconds, to: self)!
    }
    
    static func getCurrentDateStringForPayload() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateStr = formatter.string(from: date)
        return currentDateStr
    }
}

extension UIViewController {
    
    //present alert with loading indicator
//    func presentLoader() {
//        let nib = UINib(nibName: Constants.LOADERVIEW_NIB,bundle: nil)
//        if let customAlert = nib.instantiate(withOwner: self, options: nil).first as? LoaderView {
//            customAlert.tag = 12345
//            customAlert.newLoader.startAnimating()
//            customAlert.layer.cornerRadius = 10
//            customAlert.layer.masksToBounds = true
//            let screen = UIScreen.main.bounds
//            //customAlert.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - customAlert.frame.height)
//            customAlert.center = CGPoint(x: screen.midX, y: screen.midY - customAlert.frame.height)
//            self.view.addSubview(customAlert)
//        }
//    }
    //dismiss loader indicator
    func dismissCustomAlert() {
        if let view = self.view.viewWithTag(12345) {
            view.removeFromSuperview()
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboardOnTouch))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //get the colors from traffic console for each status
    func getBackGroundColor(statusCode: String) -> UIColor {
        switch statusCode {
        case Constants.WPATIENT_CODE:
            return UIColor(red: 0, green: 105, blue: 95, alpha: 1)
        case Constants.IDLE_CODE:
            return UIColor(red: 204, green: 154, blue: 5, alpha: 1)
        case Constants.PICKUP_CODE:
            return UIColor(red: 53, green: 122, blue: 56, alpha: 1)
        case Constants.ONBREAK_CODE:
            return UIColor(red: 244, green: 67, blue: 54, alpha: 1)
        case Constants.WPATIENT_ROUTE_CODE:
            return UIColor(red: 2, green: 118, blue: 170, alpha: 1)
        default:
            return UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        }
    }
    
    @objc func dismissKeyboardOnTouch() {
        view.endEditing(true)
    }
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: Constants.OK, style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension String {
    
    func dateFromString() -> Date? {
        let dateFormatter:DateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
               if let dtDate = dateFormatter.date(from: self) {
                return dtDate
               }
               return nil
    }
    
    func app_dateFromString(strDate:String, format:String) -> Date? {

        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let dtDate = dateFormatter.date(from: strDate){
            return dtDate as Date?
        }
        return nil
    }
    
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func toImage(font:UIFont, color:UIColor, insets:UIEdgeInsets? = nil) -> UIImage? {
        
        let string = self as NSString
        let attributes:[NSAttributedString.Key : Any] = [.font : font, .foregroundColor : color]
        let textSize = string.size(withAttributes: attributes)
        let maxVal = max(textSize.width, textSize.height)
        let hInsets = (insets?.left ?? 0.0) + (insets?.right ?? 0.0)
        let vInsets = (insets?.top ?? 0.0) + (insets?.bottom ?? 0.0)
        let imageSize = CGSize(width: maxVal + hInsets,
                               height: maxVal + vInsets)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize.width, height: imageSize.height), false, UIScreen.main.scale)
        string.draw(in: CGRect(origin: CGPoint(x: (imageSize.width - textSize.width) / 2.0, y: (imageSize.height - textSize.height) / 2.0), size: textSize), withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .center) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension UserDefaults{
    
    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        //synchronize()
    }
    
    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    //MARK: Save User Data
    func setUserID(value: String){
        set(value, forKey: UserDefaultsKeys.userID.rawValue)
        //synchronize()
    }
    
    //MARK: Retrieve User Data
    func getUserID() -> String{
        return string(forKey: UserDefaultsKeys.userID.rawValue)!
    }
    
    func setTokenId(value:String) {
        set(value, forKey: UserDefaultsKeys.tokenID.rawValue)
    }
    func getTokenId() -> String? {
        return string(forKey: UserDefaultsKeys.tokenID.rawValue)
    }
    
    func setRecentChats(value:[String]?) {
        set(value, forKey: UserDefaultsKeys.recentChats.rawValue)
    }
    
    func getRecentChats() -> [String]? {
        return array(forKey: UserDefaultsKeys.recentChats.rawValue) as? [String]
    }
    
    func setMutedContactUsers(value:[String]?) {
        set(value, forKey: UserDefaultsKeys.mutedContactUsers.rawValue)
    }
    
    func getMutedContactUsers() -> [String]? {
        return array(forKey: UserDefaultsKeys.mutedContactUsers.rawValue) as? [String]
    }
    
    func setBadgeLogTiers(value:[Double]?) {
        set(value, forKey: UserDefaultsKeys.badgeLogTiers.rawValue)
    }
    
    func getBadgeLogTiers() -> [Double]? {
        return array(forKey: UserDefaultsKeys.badgeLogTiers.rawValue) as? [Double]
    }
    
    func setBeaconsRoundRobinIsEnabled(value:Bool) {
        set(value, forKey: UserDefaultsKeys.isBeaconsRoundRobinEnabled.rawValue)
    }
    
    func getBeaconsRoundRobinIsEnabled() -> Bool {
        return bool(forKey: UserDefaultsKeys.isBeaconsRoundRobinEnabled.rawValue)
    }
    
    func setBeaconsRoundRobinMaxConcurrentRegions(value:Int) {
        set(value, forKey: UserDefaultsKeys.beaconsRoundRobinMaxConcurrentRegions.rawValue)
    }
    
    func getBeaconsRoundRobinMaxConcurrentRegions() -> Int {
        return self.integer(forKey: UserDefaultsKeys.beaconsRoundRobinMaxConcurrentRegions.rawValue)
    }
    
    func setBeaconsRoundRobinTime(value:Int) {
        set(value, forKey: UserDefaultsKeys.beaconsRoundRobinTime.rawValue)
    }
    
    func getBeaconsRoundRobinTime() -> Int {
        return self.integer(forKey: UserDefaultsKeys.beaconsRoundRobinTime.rawValue)
    }
    
    func setwasLaunchedBefore(value: Bool) {
        set(value, forKey: UserDefaultsKeys.wasLaunchedBefore.rawValue)
    }
    
    func wasLaunchedBefore()-> Bool {
        return bool(forKey: UserDefaultsKeys.wasLaunchedBefore.rawValue)
    }
}

enum UserDefaultsKeys : String {
    case isLoggedIn
    case userID
    case tokenID
    case recentChats
    case mutedContactUsers
    case badgeLogTiers
    case isBeaconsRoundRobinEnabled
    case beaconsRoundRobinMaxConcurrentRegions
    case beaconsRoundRobinTime
    case wasLaunchedBefore
}

// remove value for userdefault
//UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userID)

//retrive data
//UserDefaults.standard.getUserID()

extension UIApplication {

        class func getTopViewController(base: UIViewController?) -> UIViewController? {

            if let nav = base as? UINavigationController {
                return getTopViewController(base: nav.visibleViewController)

            } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
                return getTopViewController(base: selected)

            } else if let presented = base?.presentedViewController {
                return getTopViewController(base: presented)
            }
            return base
        }
    }
    
   


extension UIApplication {
    func getTopThreadSafe(completion: @escaping(UIViewController?) -> Void) {
        DispatchQueue.main.async {
            if let topMostVC: UIViewController = UIApplication.shared.keyWindow?.rootViewController {
                if let top = UIApplication.getTopViewController(base: topMostVC) {
                completion(top)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
}



extension UIDevice {
    static func notifySuccesWithSound() {
        Sound.play(file: "succes", fileExtension: "mp3", numberOfLoops: 0)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    static func notifyWarningWithSound() {
        Sound.play(file: "warning", fileExtension: "mp3", numberOfLoops: 0)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    static func notifyDangerWithSound() {
        Sound.play(file: "danger", fileExtension: "mp3", numberOfLoops: 0)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
}

extension MKMapView {
    var zoomLevel:Double {
        return floor((log2(360 * ((Double(self.frame.size.width) / 256) / self.region.span.longitudeDelta)) - 1) * 100) / 100
    }

    var scale:Double {
        return -1 * sqrt(1 - pow(self.zoomLevel / 20, 2.0)) + 1.4
    }
}

extension Array {
    subscript(safe index:Index) -> Element? {
        
        if index >= 0 && index < self.count {
            return self[index]
        }
        return nil
    }
    
    func insertionIndexOf(_ elem:Element, isOrderedBefore:(Element, Element) -> Bool) -> Int {
        var low = 0
        var high = self.count - 1
        
        while low <= high {
            let mid = (low + high) / 2
            if isOrderedBefore(self[mid], elem) {
                low = mid + 1
            }
            else if isOrderedBefore(elem, self[mid]) {
                high = mid - 1
            }
            else {
                return mid
            }
        }
        return low
    }
}

extension AppDelegate {
    static func topMostController() -> UIViewController? {
           guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
               return nil
           }

           var topController = rootViewController

           while let newTopController = topController.presentedViewController {
               topController = newTopController
           }

           return topController
       }
}

extension Date {
    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func compare(with date: Date, only component: Calendar.Component) -> Int {
           let days1 = Calendar.current.component(component, from: self)
           let days2 = Calendar.current.component(component, from: date)
           return days1 - days2
    }
    
    func toString(dateStyle:DateFormatter.Style, timeStyle:DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: self)
    }
    
    func noSeconds() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        if let noSecondsDate = Calendar.current.date(from: components) {
            return noSecondsDate
        }
        return self
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        self.layer.add(animation, forKey: "shake")
    }
}

extension Date {

    // MARK:- APP SPECIFIC FORMATS

    func app_dateFromString(strDate:String, format:String) -> Date? {

        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let dtDate = dateFormatter.date(from: strDate){
            return dtDate as Date?
        }
        return nil
    }


    func stringFromDate() -> String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        let strdt = dateFormatter.string(from: self as Date)
        if let dtDate = dateFormatter.date(from: strdt){
            return dateFormatter.string(from: dtDate)
        }
        return "--"
    }
    
    func stringFromDateZuluFormat() -> String {
          let dateFormatter2 = ISO8601DateFormatter()
        dateFormatter2.formatOptions = [.withFullTime, .withInternetDateTime, .withFractionalSeconds]
           let date = dateFormatter2.string(from: self)
        print(date)
         return date
       }

    func app_stringFromDate_timeStamp() -> String {
        return "\(self.hourTwoDigit):\(self.minuteTwoDigit) \(self.AM_PM)  \(self.monthNameShort) \(self.dayTwoDigit)"
    }


    func getUTCFormateDate(localDate: NSDate) -> String {

        let dateFormatter:DateFormatter = DateFormatter()
        let timeZone: NSTimeZone = NSTimeZone(name: "UTC")!
        dateFormatter.timeZone = timeZone as TimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let dateString: String = dateFormatter.string(from: localDate as Date)
        return dateString
    }


    func combineDateWithTime(date: NSDate, time: NSDate) -> NSDate? {
        let calendar = NSCalendar.current


        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date as Date)

        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time as Date)


        let mergedComponments = NSDateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!

        return calendar.date(from: mergedComponments as DateComponents) as NSDate?
    }

    func getDatesBetweenDates(startDate:NSDate, andEndDate endDate:NSDate) -> [NSDate] {
        let gregorian: NSCalendar = NSCalendar.current as NSCalendar;
        let components = gregorian.components(NSCalendar.Unit.day, from: startDate as Date, to: endDate as Date, options: [])
        var arrDates = [NSDate]()
        for i in 0...components.day!{
            arrDates.append(startDate.addingTimeInterval(60*60*24*Double(i)))
        }
        return arrDates
    }


    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false

        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }

        //Return Result
        return isGreater
    }

    func isLessThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false

        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }

        //Return Result
        return isLess
    }

    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false

        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }

        //Return Result
        return isEqualTo
    }


    // MARK:- TIME
    var timeWithAMPM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        return dateFormatter.string(from: self as Date)
    }




    // MARK:- YEAR


    var yearFourDigit_Int: Int {
        return Int(self.yearFourDigit)!
    }

    var yearOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y"
        return dateFormatter.string(from: self as Date)
    }
    var yearTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        return dateFormatter.string(from: self as Date)
    }
    var yearFourDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self as Date)
    }



    // MARK:- MONTH

    var monthOneDigit_Int: Int {
        return Int(self.monthOneDigit)!
    }
    var monthTwoDigit_Int: Int {
        return Int(self.monthTwoDigit)!
    }


    var monthOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: self as Date)
    }
    var monthTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self as Date)
    }
    var monthNameShort: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self as Date)
    }
    var monthNameFull: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self as Date)
    }
    var monthNameFirstLetter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMMM"
        return dateFormatter.string(from: self as Date)
    }

    // MARK:- DAY

    var dayOneDigit_Int: Int {
        return Int(self.dayOneDigit)!
    }
    var dayTwoDigit_Int: Int {
        return Int(self.dayTwoDigit)!
    }

    var dayOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self as Date)
    }
    var dayTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self as Date)
    }
    var dayNameShort: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self as Date)
    }
    var dayNameFull: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self as Date)
    }
    var dayNameFirstLetter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: self as Date)
    }




    // MARK:- AM PM
    var AM_PM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        return dateFormatter.string(from: self as Date)
    }

    // MARK:- HOUR


    var hourOneDigit_Int: Int {
        return Int(self.hourOneDigit)!
    }
    var hourTwoDigit_Int: Int {
        return Int(self.hourTwoDigit)!
    }
    var hourOneDigit24Hours_Int: Int {
        return Int(self.hourOneDigit24Hours)!
    }
    var hourTwoDigit24Hours_Int: Int {
        return Int(self.hourTwoDigit24Hours)!
    }
    var hourOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h"
        return dateFormatter.string(from: self as Date)
    }
    var hourTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh"
        return dateFormatter.string(from: self as Date)
    }
    var hourOneDigit24Hours: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H"
        return dateFormatter.string(from: self as Date)
    }
    var hourTwoDigit24Hours: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self as Date)
    }

    // MARK:- MINUTE

    var minuteOneDigit_Int: Int {
        return Int(self.minuteOneDigit)!
    }
    var minuteTwoDigit_Int: Int {
        return Int(self.minuteTwoDigit)!
    }

    var minuteOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "m"
        return dateFormatter.string(from: self as Date)
    }
    var minuteTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self as Date)
    }


    // MARK:- SECOND

    var secondOneDigit_Int: Int {
        return Int(self.secondOneDigit)!
    }
    var secondTwoDigit_Int: Int {
        return Int(self.secondTwoDigit)!
    }

    var secondOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "s"
        return dateFormatter.string(from: self as Date)
    }
    var secondTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        return dateFormatter.string(from: self as Date)
    }
}

extension Double {
    func rounded(toNumberOfDecimals decimals:Int) -> Double {
        let divisor = pow(10.0, Double(decimals))
        return (self * divisor).rounded() / divisor
    }
}


extension NSObject {
    var className: String {
        return NSStringFromClass(type(of: self))
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension Data {
    func toJSON<T:Decodable>(type:T.Type) -> T? {
        
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(T.self, from: self)
            return jsonData
        }
        catch let err {
            print("Error parsing json: \(err.localizedDescription)")
            return nil
        }
    }
}


extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}

extension UIButton {
    func allowTextToScale(minFontScale: CGFloat = 0.5, numberOfLines: Int = 1)

    {
        self.titleLabel?.adjustsFontSizeToFitWidth = true

        self.titleLabel?.minimumScaleFactor = minFontScale

        self.titleLabel?.lineBreakMode = .byTruncatingTail

        // Caution! The above causes numberOfLines to become 1,

        //  so this next line must be AFTER that one.

        self.titleLabel?.numberOfLines = numberOfLines

    }

}

extension UIImage {

//    func colorized(color : UIColor) -> UIImage {
//
//        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
//      //  let rect = CGRectMake(0, 0, self.size.width, self.size.height);
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
//        let context = UIGraphicsGetCurrentContext();
//        context!.setBlendMode(.multiply)
//        CGContext.dra
//        CGContextDrawImage(context, rect, self.CGImage)
//        CGContextClipToMask(context, rect, self.CGImage)
//        CGContextSetFillColorWithColor(context, color.CGColor)
//        CGContextFillRect(context, rect)
//        let colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return colorizedImage
//    } 121212
}

extension UINavigationController {

    var rootViewController: UIViewController? {
        return viewControllers.first
    }

}

extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}

