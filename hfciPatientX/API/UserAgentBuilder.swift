//
//  UserAgentBuilder.swift
//  NovaTrack
//
//  Created by developer on 5/13/19.
//  Copyright © 2019 Paul Zieske. All rights reserved.
//


import Foundation
import UIKit

//eg. Darwin/16.3.0
func DarwinVersion() -> String {
    var sysinfo = utsname()
    uname(&sysinfo)
    let dv = String(bytes: Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    return "Darwin/\(dv)"
}
//eg. CFNetwork/808.3
func CFNetworkVersion() -> String {
    let dictionary = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary!
    let version = dictionary?["CFBundleShortVersionString"] as! String
    return "CFNetwork/\(version)"
}

//eg. iOS/10_1
func deviceVersion() -> String {
    let currentDevice = UIDevice.current
    return "\(currentDevice.systemName)/\(currentDevice.systemVersion)"
}

func deviceIosVersion() -> String {
    let currentDevice = UIDevice.current
    return "\(currentDevice.systemVersion)"
}
//eg. iPhone5,2
func deviceName() -> String {
    var sysinfo = utsname()
    uname(&sysinfo)
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
}
//eg. MyApp/1
func appNameAndVersion() -> String {
    return "\(appName()) | Version/\(appVersion())"
}

func appName() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let name = dictionary["CFBundleName"] as! String
    return "\(name)"
}

func appVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
       let version = dictionary["CFBundleShortVersionString"] as! String
       return version
}

func appBuild() -> String {
    guard let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else { return "" }
    return build
}

func appNetworkConnection() -> String {
    return "NetworkConnection/\(NetworkManager.shared.conectionBy)"
    
}

func UserAgentString() -> String {
    return "\(appNameAndVersion()) | Build/\(appBuild()) | Device Name/\(deviceName()) | \(deviceVersion()) | \(CFNetworkVersion()) | \(appNetworkConnection()) | \(DarwinVersion())"
}
