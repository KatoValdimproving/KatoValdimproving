//
//  PayloadCreator.swift
//  NovaTrack
//
//  Created by developer on 12/4/19.
//  Copyright © 2019 Paul Zieske. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftKeychainWrapper

enum Service {
    case pubnub
    case socketIO
    case none
}

struct PayloadKeys {
    static let wifiSettingSwitch = "wifiSettingSwitch"
    static let battery = "battery"
    static let userAgent = "User-Agent"
    static let deviceId = "device_id"
    static let jobId = "jobId"
    static let delayCode = "delay_code"
    static let userId = "user_id"
    static let statusCode = "status_code"
    static let ssid = "SSID"
    static let createDate = "create_date"
    static let geolocation = "geolocation"
    static let socketIOEnabled = "isSocketIOEnabled"
    static let chunkId = "chunkId"
    static let isNetworkAvailable = "isNetworkAvailable"
    static let logId = "log_id"
    static let isConnectedToValidNetwork = "isConnectedToValidNetwork"
    static let conectedBy = "conectedBy"
    static let sentToBackend = "sentToBackend"
    static let session = "session"
    static let validSSIDs = "validSSIDs"
    static let isAppInBackground = "isAppInBackground"
    static let locationPermissions = "locationPermissions"
    
}

struct ShortPayloadKeys {
    
    //[
    //    "jId": "604a4fdd92ebb7001e191963",    //jobId
    //    "uId": "5e31890dba5dd7001a3a2ae5",    //userId
    //    "isSoc": true,                        //isSocketIOEnabled
    //    "cDate": "2021-03-11T17:19:18.176Z",  //createDate
    //    "conn": "wifi",                       //connectedBy
    //    "SSID": "The Gate",                   //SSID
    //    "isNet": true,                        //isNetworkAvailable
    //    "loc": ["lg": -103.36569400290541, "lt": 20.74654287762375, "flr": "outside"], //geolocation:[longitud: latitud: floor]
    //    "lId": 56107,                         //logId
    //    "cId": 11209,                         // chunkId
    //    "isBkd": false,                       //isAppInBackground
    //    "dId": "111111",                      //deviceId
    //    ]
    
    static let jobId = "jId" //
    static let userId = "uId" //
    static let socketIOEnabled = "isSoc" //
    static let createDate = "cDate"//
    static let conectedBy = "conn"//
    static let ssid = "SSID" //
    static let isNetworkAvailable = "isNet" //
    static let geolocation = "loc" //
    static let logId = "lId"//
    static let chunkId = "cId" //
    static let isAppInBackground = "isBkd" //
    static let deviceId = "dId" //
    static let statusCode = "sCode"

}

class PayloadCreator {
    
    static let shared = PayloadCreator()
    var payload = [String: Any]()
    
    init() {}
    
    private func appendToPayload(dictionary: [String: Any]?) {
        guard let params = dictionary else { return }
        payload = self.payload.merging(params) { (_, second) -> Any in
            second
        }
    }
    
    
    private func cleanPayload() {
        payload = [:]
    }
    
    
    //------------------------------------------------
    
    //wifi switch
    func getWifiSwitchStatus() -> Bool {
        return NetworkManager.shared.isWiFiOn()
    }
    
    private func getWifiSwitchStatusForPayload() -> [String: Any]? {
        return [PayloadKeys.wifiSettingSwitch: getWifiSwitchStatus()]
    }
    
    
    
    //
    
    //baterry
    
    func getBatteryLevel() -> Double {
        return Double(UIDevice.current.batteryLevel)
    }
    
    private func getBatteryLevelForPayload() -> [String: Any]? {
        return [PayloadKeys.battery: getBatteryLevel()]
    }
    
    //device id
    
    func getDeviceId() -> String? {
        return SettingsBundleHelper.shared.testerId
    }
    
    private func getDeviceIdForPayload() -> [String: Any]? {
        guard let deviceId = getDeviceId() else { return nil }
        return [PayloadKeys.deviceId: deviceId]
    }
    
    private func getDeviceIdForShortPayload() -> [String: Any]? {
        guard let deviceId = getDeviceId() else { return nil }
        return [ShortPayloadKeys.deviceId: deviceId]
    }
    
    //user agent
    func getUserAgent() -> String {
        return UserAgentString()
    }
    
    private func getUserAgentForPayload() -> [String: Any]? {
        return [PayloadKeys.userAgent: UserAgentString()]
    }
    
    
    //job id
    
    func getJobId() -> String? {
        guard let jobId = JobManager.jobId else { return nil }
        return jobId
    }
    
    private func getJobIdForPayload() -> [String: Any]? {
        guard let jobId = getJobId() else { return nil }
        return [PayloadKeys.jobId: jobId]
    }
    
    private func getJobIdForShortPayload() -> [String: Any]? {
        guard let jobId = getJobId() else { return nil }
        return [ShortPayloadKeys.jobId: jobId]
    }
    
    //delay code
    
    func getDelayCode() -> String {
        return PayloadKeys.delayCode
    }
    
    private func getDelayCodeForPayload() -> [String: Any]? {
        return [PayloadKeys.delayCode: ""]
    }
    
    
    // user id
    
    func getUserId() -> String? {
        return SessionManager.shared.user?.userId
        
    }
    
    private func getUserIdForPayload() -> [String: Any]? {
        guard let userId = getUserId() else { return nil }
        return [PayloadKeys.userId: userId]
    }
    
    private func getUserIdForShortPayload() -> [String: Any]? {
        guard let userId = getUserId() else { return nil }
        return [ShortPayloadKeys.userId: userId]
    }
    
    
    //status code
    
    func getStatusCode() -> String {
        return Constants.STATUS_CODE_VALUE
    }
    
    private func getStatusCodeForPayload() -> [String: Any]? {
        return [PayloadKeys.statusCode: getStatusCode()]
    }
    
    private func getStatusCodeForPayload(delta: String) -> [String: Any]? {
        return [PayloadKeys.statusCode: getStatusCode()]
    }
    
    private func getStatusCodeForShortPayload() -> [String: Any]? {
        return [ShortPayloadKeys.statusCode: getStatusCode()]
    }
    
    private func getStatusCodeForShortPayload(delta: String) -> [String: Any]? {
        return [ShortPayloadKeys.statusCode: delta]
    }
    
    
    
    // ssid
    func getSSID() -> String? {
        return NetworkManager.shared.getWiFiSsid()
    }
    
    
    private func getWifiSSIDForPayload() -> [String: Any]? {
        guard let ssid = getSSID() else { return nil }
        return [PayloadKeys.ssid: ssid]
    }
    
    private func getWifiSSIDForShortPayload() -> [String: Any]? {
        guard let ssid = getSSID() else { return nil }
        return [ShortPayloadKeys.ssid: ssid]
    }
    
    
    // floor
    
    func getFloor(locations: [CLLocation]) -> Int? {
        let newLocation = locations.last
        guard let floor = newLocation!.floor?.level else { return nil}
        return floor
    }
    // geolocation
    
    
    func getCoordinatesLongitudAndLatitude(locations: [CLLocation]) -> (longitude: String, latitude: String)? {
        guard let newLocation = locations.last else { return nil }
        
        let latitude = newLocation.coordinate.latitude.description
        let longitude = newLocation.coordinate.longitude.description
        
        // Constants.LONGITUDE_KEY : newLocation!.coordinate.longitude
        return (longitude: longitude, latitude: latitude)
        
        
    }
    
    func getAccuracy(location: CLLocation) -> String {
        if #available(iOS 13.4, *) {
            let accuracyDescription = "HA: \(location.horizontalAccuracy), VA: \(location.verticalAccuracy), A: \(location.courseAccuracy), SA:\(location.speedAccuracy), S: \(location.speed)"
            return accuracyDescription
        } else {
            return "iOS NO Available"
        }
        
    }
    
    func getCoordinatesForPayload(locations: [CLLocation]) ->  [String : Any]? {
        
        var coordinatesDictionary: [String:Any] = [:]
        
        if let floor = getFloor(locations: locations) {
            coordinatesDictionary.updateValue(floor, forKey: "floor")
        } else {
            coordinatesDictionary.updateValue("outside", forKey: "floor")
        }
        
        if let coordinates = getCoordinatesLongitudAndLatitude(locations: locations) {
            
            guard let longitudeNumber = Double(coordinates.longitude), let latitudeNumber = Double(coordinates.latitude) else { return nil}
            coordinatesDictionary.updateValue(longitudeNumber, forKey: "longitude")
            coordinatesDictionary.updateValue(latitudeNumber, forKey: "latitude")
        }
        
        
        return [PayloadKeys.geolocation: coordinatesDictionary]
        
    }
    
    func getCoordinatesForShortPayload(locations: [CLLocation]) ->  [String : Any]? {
        
        var coordinatesDictionary: [String:Any] = [:]
        
        if let floor = getFloor(locations: locations) {
            coordinatesDictionary.updateValue(floor, forKey: "flr")
        } else {
            coordinatesDictionary.updateValue("outside", forKey: "flr")
        }
        
        if let coordinates = getCoordinatesLongitudAndLatitude(locations: locations) {
            
            guard let longitudeNumber = Double(coordinates.longitude), let latitudeNumber = Double(coordinates.latitude) else { return nil}
            coordinatesDictionary.updateValue(longitudeNumber, forKey: "lg")
            coordinatesDictionary.updateValue(latitudeNumber, forKey: "lt")
        }
        
        
        return [ShortPayloadKeys.geolocation: coordinatesDictionary]
        
    }
    
    
    
    
    
    private func getSocketIOStatus() -> Bool {
        return SocketIOManager.sharedInstance.isSocketIOEnabled
    }
    
    private func getSocketIOStatusForPayload() -> [String: Any] {
        return [PayloadKeys.socketIOEnabled: getSocketIOStatus()]
    }
    
    private func getSocketIOStatusForShortPayload() -> [String: Any] {
        return [ShortPayloadKeys.socketIOEnabled: getSocketIOStatus()]
    }
    
    
    // ======= Network status
    
    private func getIsNetworkAvailable() -> Bool {
        return NetworkManager.shared.isNetworkAvailable
    }
    
    private func getIsNetworkAvailableForPayload() -> [String: Any] {
        return [PayloadKeys.isNetworkAvailable: getIsNetworkAvailable()]
    }
    
    private func getIsNetworkAvailableForShortPayload() -> [String: Any] {
        return [ShortPayloadKeys.isNetworkAvailable: getIsNetworkAvailable()]
    }
    
    
    // ======= chunk
    
    private func getChunkId() -> Int {
        return ChunkIdCreator.chunkId
    }
    
    private func getChunkIdForPayload() -> [String: Any] {
        return [PayloadKeys.chunkId: getChunkId()]
    }
    
    private func getChunkIdForShortPayload() -> [String: Any] {
        return [ShortPayloadKeys.chunkId: getChunkId()]
    }
    
    
    
    // ======= date
    
    func getValidSSIDs() -> String? {
        guard let SSIDNamesString = UserDefaults.standard.string(forKey: SettingsBundleKeys.SSIDNames) else { return nil }
        return SSIDNamesString
    }
    
    private func getValidSSIDsForPayload() -> [String: Any] {
        return [PayloadKeys.validSSIDs: getValidSSIDs() ?? "n/a"]
    }
    
    
    //    func isConnectedToValidNetwork() -> Bool {
    //        guard let currentSSID = getSSID() else { return false }
    //        if SettingsBundleHelper.shared.SSIDNames.contains(currentSSID) {
    //            return true
    //        } else {
    //            return false
    //        }
    //    }
    
    //    private func getIsConnectedToValidNetworkToPayload() -> [String: Any] {
    //           return [PayloadKeys.isConnectedToValidNetwork: isConnectedToValidNetwork()]
    //    }
    
    
    func getCurrentDate() -> Date {
        return Date()
    }
    
    private func getCurrentDateToPayload() -> [String: Any] {
        return [PayloadKeys.createDate: getCurrentDate().stringFromDateZuluFormat()]
    }
    
    private func getCurrentDateToShortPayload() -> [String: Any] {
        return [ShortPayloadKeys.createDate: getCurrentDate().stringFromDateZuluFormat()]
    }
    
    private func getLogIdToPayload() -> [String: Any] {
        return [PayloadKeys.logId: IdCreator.currentId]
    }
    
    private func getLogIdToshortPayload() -> [String: Any] {
        return [ShortPayloadKeys.logId: IdCreator.currentId]
    }
    
    private func getConectedByToPayload() -> [String: Any] {
        return [PayloadKeys.conectedBy: NetworkManager.shared.conectionByToString()]
    }
    
    private func getConectedByToShortPayload() -> [String: Any] {
        return [ShortPayloadKeys.conectedBy: NetworkManager.shared.conectionByToString()]
    }
    
    
    private func getIsAppInBackgroundToPayload() -> [String: Any] {
        return [PayloadKeys.isAppInBackground: SessionManager.shared.isAppInBackground]
    }
    
    private func getIsAppInBackgroundToShortPayload() -> [String: Any] {
        return [ShortPayloadKeys.isAppInBackground: SessionManager.shared.isAppInBackground]
    }
    
    
    private func getLocationPermissionsToPayload() -> [String: Any] {
        return [PayloadKeys.locationPermissions: getCurrentLocationPermissionStatus()]
    }
    
    private func getSessionIdToPayload() -> [String: Any] {
      //  return [PayloadKeys.session: CoreDataManager.sharedInstance.currentSessionId ?? "n/a"]
        return [PayloadKeys.session: ""]

    }
    
    
    func getLocationPermissionStatus(status: CLAuthorizationStatus) -> String {
        var locationAuthorizationStatus: String
        switch status {
        case .notDetermined:
            locationAuthorizationStatus = "notDetermined"
        case .restricted:
            locationAuthorizationStatus = "restricted"
        case .denied:
            locationAuthorizationStatus = "denied"
        case .authorizedAlways:
            locationAuthorizationStatus = "authorizedAlways"
        case .authorizedWhenInUse:
            locationAuthorizationStatus = "authorizedWhenInUse"
        default:
            locationAuthorizationStatus = "unknown"
        }
        return locationAuthorizationStatus
    }
    
    func getCurrentLocationPermissionStatus() -> String {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        @unknown default:
            return ""
        }
    }
    
    
    
    func createPayload(for service: Service, with locations: [CLLocation], delta: String, and userObj: User?) -> [String: Any] {
        //var payload = [String: Any]()
        
        self.cleanPayload()
        
        self.appendToPayload(dictionary: getCoordinatesForPayload(locations: locations))
        self.appendToPayload(dictionary: getBatteryLevelForPayload())
        self.appendToPayload(dictionary: getCurrentDateToPayload())
        self.appendToPayload(dictionary: getDeviceIdForPayload())
        self.appendToPayload(dictionary: getDelayCodeForPayload())
        self.appendToPayload(dictionary: getStatusCodeForPayload(delta: delta))
        self.appendToPayload(dictionary: getJobIdForPayload())
        self.appendToPayload(dictionary: getWifiSwitchStatusForPayload())
        self.appendToPayload(dictionary: getUserIdForPayload())
        self.appendToPayload(dictionary: getUserAgentForPayload())
        self.appendToPayload(dictionary: getWifiSSIDForPayload())
        self.appendToPayload(dictionary: getSocketIOStatusForPayload())
        self.appendToPayload(dictionary: getChunkIdForPayload())
        self.appendToPayload(dictionary: getIsNetworkAvailableForPayload())
        self.appendToPayload(dictionary: getLogIdToPayload())
        
        //New Added
        //   self.appendToPayload(dictionary: getIsConnectedToValidNetworkToPayload())
        self.appendToPayload(dictionary: getConectedByToPayload())
        self.appendToPayload(dictionary: getValidSSIDsForPayload())
        self.appendToPayload(dictionary: getIsAppInBackgroundToPayload())
        self.appendToPayload(dictionary: getLocationPermissionsToPayload())
        self.appendToPayload(dictionary: getSessionIdToPayload())
        
        return self.payload
        
    }
    
    func createShortPayload(for service: Service, with locations: [CLLocation], delta: String, and userObj: User?) -> [String: Any] {

        self.cleanPayload()
        
        self.appendToPayload(dictionary: getJobIdForShortPayload())
        self.appendToPayload(dictionary: getUserIdForShortPayload())
        self.appendToPayload(dictionary: getSocketIOStatusForShortPayload())
        self.appendToPayload(dictionary: getCurrentDateToShortPayload())
        self.appendToPayload(dictionary: getConectedByToShortPayload())
        self.appendToPayload(dictionary: getWifiSSIDForShortPayload())
        
        self.appendToPayload(dictionary: getIsNetworkAvailableForShortPayload())
        self.appendToPayload(dictionary: getCoordinatesForShortPayload(locations: locations))
        self.appendToPayload(dictionary: getLogIdToshortPayload())
        self.appendToPayload(dictionary: getChunkIdForShortPayload())
        self.appendToPayload(dictionary: getIsAppInBackgroundToShortPayload())
        self.appendToPayload(dictionary: getDeviceIdForShortPayload())
        self.appendToPayload(dictionary: getStatusCodeForShortPayload(delta: delta))



        
       // print(" \(self.payload)")
        
        return self.payload
        
    }
    
    func printPayload(payload: [String:Any]) {
        
        let result = "\(PayloadKeys.geolocation): \(payload.valueForKeyPath(keyPath: PayloadKeys.geolocation) ?? "n/a")\n \(PayloadKeys.battery): \(payload.valueForKeyPath(keyPath: PayloadKeys.battery) ?? "n/a")\n  \(PayloadKeys.createDate): \(payload.valueForKeyPath(keyPath: PayloadKeys.createDate) ?? "n/a")\n  \(PayloadKeys.deviceId): \(payload.valueForKeyPath(keyPath: PayloadKeys.deviceId) ?? "n/a")\n  \(PayloadKeys.delayCode): \(payload.valueForKeyPath(keyPath: PayloadKeys.delayCode) ?? "n/a")\n \(PayloadKeys.statusCode):  \(payload.valueForKeyPath(keyPath: PayloadKeys.statusCode) ?? "n/a")\n \(PayloadKeys.jobId): \(payload.valueForKeyPath(keyPath: PayloadKeys.jobId) ?? "n/a")\n \(PayloadKeys.wifiSettingSwitch): \(payload.valueForKeyPath(keyPath: PayloadKeys.wifiSettingSwitch) ?? "n/a")\n  \(PayloadKeys.userId): \(payload.valueForKeyPath(keyPath: PayloadKeys.userId) ?? "n/a")\n  \(PayloadKeys.userAgent): \(payload.valueForKeyPath(keyPath: PayloadKeys.userAgent) ?? "n/a")\n   \(PayloadKeys.ssid): \(payload.valueForKeyPath(keyPath: PayloadKeys.ssid) ?? "n/a")\n \(PayloadKeys.socketIOEnabled): \(payload.valueForKeyPath(keyPath: PayloadKeys.socketIOEnabled) ?? "n/a")\n \(PayloadKeys.chunkId): \(payload.valueForKeyPath(keyPath: PayloadKeys.chunkId) ?? "n/a")"
        
        print("🥶\(result)\n")
        
        
    }
    
    
}
