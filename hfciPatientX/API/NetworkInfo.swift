//
//  NetworkInfo.swift
//  NovaTrack
//
//  Created by developer on 5/13/19.
//  Copyright © 2019 Paul Zieske. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

struct NetworkInfo {
    public let interface:String
    public let ssid:String
    public let bssid:String
    
    init(_ interface:String, _ ssid:String,_ bssid:String) {
        self.interface = interface
        self.ssid = ssid
        self.bssid = bssid
    }
}

func getNetworkInfos() -> Array<NetworkInfo> {
    // https://forums.developer.apple.com/thread/50302
    guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
        return []
    }
    let networkInfos:[NetworkInfo] = interfaceNames.compactMap{ name in
        guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
            return nil
        }
        guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
            return nil
        }
        guard let bssid = info[kCNNetworkInfoKeyBSSID as String] as? String else {
            return nil
        }
        return NetworkInfo(name, ssid,bssid)
    }
    return networkInfos
}
