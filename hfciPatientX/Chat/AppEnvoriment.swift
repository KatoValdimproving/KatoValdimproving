//
//  AppEnvoriment.swift
//  NovaTrack
//
//  Created by developer on 3/24/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class AppEnvoriment {
    
    static let shared = AppEnvoriment()
    var enviroment: Environment {
        get {
             let integer = UserDefaults.standard.integer(forKey: "enviroment")
            return Environment(rawValue: integer) ?? .qa
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "enviroment")
        }
    }
    private init() { }
    
    var apiBaseUrl: String {
        
        let selectedhospitalName = SettingsBundleHelper.shared.selectedHospital
        let hospitalWithEnvironment = NaavSystemEnvironment[Hospital(rawValue: selectedhospitalName.rawValue) ?? .other]
        let API = "/api/"

        switch  hospitalWithEnvironment.name {
        
        case .henryford:
           
            switch hospitalWithEnvironment.environment {
            case .dev:
                return NavvTrackEndPoints.DEV_BASE_URL + API
            case .staging:
                return NavvTrackEndPoints.STAGE_BASE_URL + API
            case .qa:
                return NavvTrackEndPoints.QA_BASE_URL + API
            case .prod:
                return NavvTrackEndPoints.PROD_BASE_URL + API
            case .local:
                return NavvTrackEndPoints.LOCAL_BASE_URL + API
            }
                
        case .lahey:
            
            switch hospitalWithEnvironment.environment {
            case .dev:
                return LaheyEndpoints.DEV_BASE_URL + API
            case .staging:
                return LaheyEndpoints.STAGE_BASE_URL + API
            case .qa:
                return LaheyEndpoints.QA_BASE_URL + API
            case .prod:
                return LaheyEndpoints.PROD_BASE_URL + API
            case .local:
                return LaheyEndpoints.LOCAL_BASE_URL + API
            }
            
            
       
        case .other:
            return NavvTrackEndPoints.DEV_BASE_URL + API
        }
        
    }
        
    var ADBaseUrl: String {
        let selectedhospitalName = SettingsBundleHelper.shared.selectedHospital
        let hospitalWithEnvironment = NaavSystemEnvironment[Hospital(rawValue: selectedhospitalName.rawValue) ?? .other]

        switch  hospitalWithEnvironment.name {

        case .henryford:
            
            switch hospitalWithEnvironment.environment {
            case .dev:
                return "http://dev-hfhs.navvtrak.com:3050/api/loginSAML"
            case .staging:
                return "http://sandbox-hfhs.navvtrak.com:3050/api/loginSAML"
            case .qa:
                return "http://qa-hfhs.navvtrak.com:3050/api/loginSAML"
            case .prod:
                return "http://novatrack.hfhs.org:3050/api/loginSAML"
            case .local:
                return ""
            }
            
        case .lahey:
                        
            switch hospitalWithEnvironment.environment {
            case .dev:
                return ""
            case .staging:
                return "http://lahey.navvtrak.com:3050/api/loginSAML"
            case .qa:
                return ""
            case .prod:
                return "http://navvtrack.lahey.org:3050/api/loginSAML"
            case .local:
                return ""
            }
        case .other:
            return "http://dev-hfhs.navvtrak.com:3050/api/loginSAML"
        }
    }
}
