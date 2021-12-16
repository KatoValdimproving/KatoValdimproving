//
//  Constants.swift
//  NovaTrack
//
//  Created by Developer on 1/11/18.
//  Copyright © 2018 Paul Zieske. All rights reserved.
//

import UIKit


struct NavvTrackEndPoints {
    static let PROD_BASE_URL = "https://novatrack.hfhs.org"
    static let STAGE_BASE_URL = "https://sandbox-hfhs.navvtrak.com"
    static let QA_BASE_URL = "https://qa-hfhs.navvtrak.com"
    static let DEV_BASE_URL = "https://dev-hfhs.navvtrak.com"
    static let LOCAL_BASE_URL = "http://localhost:3050"

    static let SBOX_ROUTE_URL = "https://sandbox-hfhs.navvtrak.com/django/api/v1/directions/startid=%@&endid=%@&type=0/?format=json"
    static let PROD_ROUTE_URL = "http://wayfinding.hfhs.org/django/api/v1/directions/startid=%@&endid=%@&type=0/?format=json"
}

struct LaheyEndpoints {
    static let PROD_BASE_URL = "https://navvtrack.lahey.org"
    static let STAGE_BASE_URL = "https://lahey.navvtrak.com"
    static let QA_BASE_URL = "https://lahey.navvtrak.com"
    static let DEV_BASE_URL = "https://lahey.navvtrak.com"
    static let LOCAL_BASE_URL = "http://172.20.160.85:3050"
    
    static let SBOX_ROUTE_URL = "https://lahey.navvtrak.com/django/api/v1/directions/startid=%@&endid=%@&type=0/?format=json"
    static let PROD_ROUTE_URL = "http://wayfinding.hfhs.org/django/api/v1/directions/startid=%@&endid=%@&type=0/?format=json"
}

struct WebLinkRoute {
    
    static var BASE_URL = ""
    static var ROUTE_URL = ""
}

enum Environment: Int {
    case prod
    case qa
    case dev
    case staging
    case local
}

struct HospitalWithEnvironment {
    let name: Hospital
    var environment: Environment
    var apiBaseUrl: String {
        return AppEnvoriment.shared.apiBaseUrl
    }
}

struct NaavSystemEnvironment {
    
    static var currentEntenvironment = Environment.dev
    
    static var hospitals = [HospitalWithEnvironment(name: .henryford, environment: currentEntenvironment),
                            HospitalWithEnvironment(name: .lahey, environment: currentEntenvironment)]
    
    
    static subscript (name: Hospital) -> HospitalWithEnvironment {
       return hospitals.first { (hospital) -> Bool in
            return hospital.name == name
       } ?? HospitalWithEnvironment(name: .other, environment: .staging)
    }
    
    static func changeEnvironment(newEnvironment: Environment) {
        currentEntenvironment = newEnvironment
        for (index, _) in hospitals.enumerated() {
            hospitals[index].environment = newEnvironment
        }
    }
    
}




class Constants: NSObject {
    
    static var ALL_USERS : [[String : AnyObject]]? = nil
    
    static var floorColorPins = [UIImage(named: "EquipmentDot_filled_0"),
                                 UIImage(named: "EquipmentDot_filled_1"),
                                 UIImage(named: "EquipmentDot_filled_2"),
                                 UIImage(named: "EquipmentDot_filled_3"),
                                 UIImage(named: "EquipmentDot_filled_4"),
                                 UIImage(named: "EquipmentDot_filled_5"),
                                 UIImage(named: "EquipmentDot_filled_6"),
                                 UIImage(named: "EquipmentDot_filled_7"),
                                 UIImage(named: "EquipmentDot_filled_8"),
                                 UIImage(named: "EquipmentDot_filled_9"),
                                 UIImage(named: "EquipmentDot_filled_10"),
                                 UIImage(named: "EquipmentDot_filled_11"),
                                 UIImage(named: "EquipmentDot_filled_12"),
                                 UIImage(named: "EquipmentDot_filled_13"),
                                 UIImage(named: "EquipmentDot_filled_14"),
                                 UIImage(named: "EquipmentDot_filled_15"),
                                 UIImage(named: "EquipmentDot_filled_16"),
                                 UIImage(named: "EquipmentDot_filled_17"),
                                 UIImage(named: "EquipmentDot_filled_18")]
    
    static let PHONE_IDENTIFIER = "phone_indentifier"
  
    
    static var loading = false
    
   // static let PUBNUB_PUBLISH_IDENTIFIER = "pubnub_publish_key"
  //  static let PUBNUB_SUBSCRIBE_IDENTIFIER = "pubnub_subscribe_key"
    static let SCANNING_MESSAGE = "Use finger scanning"
    static let TOUCH_NOT_AVAILABLE = "Touch ID not available"
    static let TOUCH_NOT_AVAILABLE_MSG = "Your device is not configured for Touch ID."
  //  static let SSID_KEY = "SSID"
    static var JOB_ID = ""
    static let CHANNEL_KEY = "channel"
    static let COMMON_CHANNEL_KEY = "CommonChannel"
    static let USERID_KEY = "userID"
    static let HFH_CHANNEL_1 =  "HFHTransport-1" //"hfhchannel1" //
    static let COMMONCHANEL = "common-channel"
    static let USER =  "1"
    static let TRACK_KEY = "track"
    static let LOG_VC = "LogViewController"
    static let MAX_FLOOR:Double = 16
    static let MIN_FLOOR: Double = -2
    static let ENTER_CODE = "Enter Code"
    static let CODE_ALERT_MESSAGE = "write your own code"
    static let CODE_ALERT_PLACEHOLDER = "Bar code"
    static let ACCEPT = "Accept"
    static var loggedBattery = false
    static var loggedSSID = false
    static let serviceName = "N0V4s3Rv1c3Kchain"
    static let accessGroup = "N0V4s3Rv1c344ccssgrp"
    static let BASE_IMAGES = "https://itxlin01.itexico.com/static/media/dCodes/"
    static let FORGOT_PASSWORD_TITLE = "Forgot Password"
    static let FORGOT_PASSWORD_MSG = "Contact Novatrack Administrator"
    static let SEEN_KEY = "seen"
    static let SEEN_MSG = "Seen"
    static let DEVICE_ID_KEY = "device_id"
    
    
    
    static let ROUTE_URL_KEY = "route_url"
    static var chattingWith = ""
    //MARK: segues
    static let SCANQR_SEGUE = "scanQR"
    static let SEGUE_DESTINATION = "destination"
    static let SEGUE_ORGANIZATION = "Organization"
    static let SEGUE_NEWCHAT = "NewChat"
    static let SEGUE_TOORG = "toOrgVC"
    
    //MARK: APIManagerStringConstants
    static let ERROR_TITLE = "Error"
    static let TTL_KEY = "ttl"
    static let TTL_VALUE = 60 * 60 * 12// seg * min (* hour) -- 43200
    
    //MARK: PubNubManager constants
    static let PUBNUB_DATE_FORMATTER = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    static let GEOLOCATION_KEY = "geolocation"
    static let LATITUDE_KEY = "latitude"
    static let LONGITUDE_KEY = "longitude"
    static let FLOOR_KEY = "floor"
    static let CREATE_DATE_KEY = "create_date"
    static let DELAY_CODE_KEY = "delay_code"
    static let STATUS_CODE_KEY = "status_code"
    static var STATUS_CODE_VALUE = IDLE_CODE
    static let IDLE_CODE = "idle"
    static let ONBREAK_CODE = "On break"
    static let WPATIENT_CODE = "with patient"
    static let WPATIENT_ROUTE_CODE = "with patient + route"
    static let PICKUP_CODE = "To pick up location"
    static let JOB_ID_KEY = "jobId"
    static let USER_ID_KEY = "user_id"
    static let BATTERY_KEY = "battery"
    static var logged_in = false
    static let BATTERY_PERCENTAGE: Float = 0.31
    static let USER_AGENT = "User-Agent"
    
    //MARK: User constants
    static let ID_JSON_KEY = "id"
    static let USER_ID_JSON_KEY = "userId"
    static let TTL_JSON_KEY = "ttl"
    static let CREATED_JSON_KEY = "created"
    
    //MARK: DelayCode constants
    static let DELAY_TIME_JSON_KEY = "delay_time"
    static let DESCRIPTION_JSON_KEY = "description"
    static let COLOR_JSON_KEY = "color"
    static let IMAGE_JSON_KEY = "image"
    
    //MARK: LoginViewController constants
    static let FORGOT_PASSWORD_VC = "ForgotPasswordViewController"
    static let TABBAR_VC = "TabBarViewController"
    static let DRAWER_TABLE_VC = "DrawerTableViewController"
    static let EMAIL = "Email"
    static let PASSWORD = "Password"
    static let STORYBOARD_NAME = "Main"
    static let CANCEL = "Cancel"
    static let IMG_WARNING = "ic_warning"
    static let ERROR_FILL_PASSWORD = "Password must not be blank"
    static let ERROR_EMAIL = "Incorrect Email"
    static let ERROR_CREDENTIALS = "The user name or password is invalid"
    static let USE_NAME_KEY = "username"
    static let NAME_DRAWER_KEY = "name_drawer"
    
    //MARK: Extensions Constants
    static let OK = "OK"
    static let LOADERVIEW_NIB = "LoaderViewPersonalized"
    
    //MARK: DestViewController constants
    static let TITLE_HENRYFORD = "Henry Ford"
    static let HFH_SUBTITLE = "HFH"
    static let FLOOR_TEXT = "Floor"
    static let DUMMY_DIRECTION = "DummyDirection"
    static let TYPE_GEOJSON = "geojson"
    static let MAP_TITLE_ANNOTATION = "Crema to Council Crest"
    
    //MARK: LogViewController
    static let LOG_CELL_IDENTIFIER = "LogCell"
    static let INFORMATION_TVC = "InformationTVC"
    static let DEPARTMENT = "department"
    static let LOGCELL_IDENTIFIER = "LogCell"
    
    //MARK: NavViewController
    static let IMG_IC_START = "ic_start"
    static let IMG_IC_FINISH = "ic_finish"
    static let VC_NAME_ORG_VIEWCONTROLLER = "OrgViewController"
    static let VC_NAME_MAP_VIEWCONTROLLER = "MapViewController"
    static let NC_NAV_VIEWCONTROLLER = "NavViewControllerNC"
    static let DEST_VIEWCONTROLLER = "DestViewController"
    static let ROUTE_TITLE = "Route"
    
    //MARK: OrgViewController
    static let FLOOR_TYPE_OUTDOORS = "Outdoors"
    static let GROUND = "Ground"
    static let BASEMENT = "Basement"
    static let EMERGENCY = "Emergency"
    static let DASHED_POLYLINE = "dashed-polyline"
    static let POLYLINE = "polyline"
    static let GEOMETRY_KEY = "geometry"
    static let PROPERTIES_KEY = "properties"
    static let CURRENT_LOCATION = "CurrentLocation"
    static let COORDINATE_KEY = "coordinates"
    static let BASEMENT_AB = "B"
    static let EMERGENCY_AB = "E"
    static let GROUND_AB = "G"
    
    //MARK: NewChatViewController
    static let NEW_CHAT_TILE = "New Conversation"
    
    //MARK: DrawerTableViewController
    static let HEADER_CELL_IDENTIFIER = "HeaderCell"
    static let CELL_IDENTIFIER = "Cell"
    static let TEXT_EMAIL = "Email"
    static let TEXT_NAME = "Name"
    static let LOGINVC_NAME = "LoginViewController"
    static let LOGOUT_ALERT_TITLE = "!!LOGOUT!!"
    static let LOGOUT_ALERT_MESSAGE = "you are logout"
    
    //MARK: MessageListViewController
    static let TITLE_NEW = "New"
    static let TITLE_MESSAGES = "Messages"
    static let NEW_CHAT_VC_NAME = "NewChatViewController"
    static let KEYPATH_LIST = "list"
    static let MSG_CEll_IDENTIFIER = "MSGCell"
    static let TEXT_STATUS = "status"
    static let TEXT_OFFLINE = "offline"
    static let CHAT_MSG_VC_NAME = "ChatMessageViewController"
    static let TEXT_ALIVE = "alive"
    static let KEYPATH_INITIAL = "initial"
    static let KEYPATH_NAME = "name"
    static let NEW_MESSAGE_TITLE = "New message from %@"
    static let CONTINUE = "Continue"
    static let NEW_CHAT_KEY = "newChat"
    static let ORIGIN = "origin"
    static let ALARM_IDENTIFIER = "alarm"
    static let UNREADED_MESSAGES = "unread messages"
    
    //MARK: TicketViewController
    static let TICKETVC_TITLE = "Patient Match"
    static let PATIENTNAME_CELL_IDENTIFIER = "PatientNameCell"
    static let PATIENT_INFO_CELL_IDENTIFIER = "PatientInfoCell"
    static let START_LOCATION = "Start location"
    static let FINISH = "Finish"
    static let INFORMATIONTVC = "InformationTableViewCell"
    static let MRN_KEY = "mrn"
    static let PATIENT_KEY = "patitent"
    static let NAME_KEY = "name"
    static let ROOM_KEY = "room"
    static let RIDE_HEADER = "Ride Information"
    static let PATIENT_HEADER = "Patient Information"
    static let PANIC_ALERT_TITLE = "Update Status"
    static let BLOOD_TYPE = "Blood type"
    static let PATIENT_DETAIL = "Patient Detail"
    static let PANIC_ALERT_MESSAGE = "You'll change status from \"On Route\" to \"With Patient\"."
    static let T_PANIC_CELL_IDENTIFIER = "panicCell"
    
    //MARK: ChatMessageViewController
    static let NIB_SENDER_TABLEVIEW_CELL = "SenderTableViewCell"
    static let SENDER_CELL_IDENTIFIER = "senderCell"
    static let NIB_RECEIVER_TABLEVIEW_CELL = "ReceiverTableViewCell"
    static let RECEIVER_CELL_IDENTIFIER = "receiverCell"
    static let PANIC_CELL_IDENTIFIER = "PanicCell"
    static let IMG_CHAT_BUBBLE_SENT = "chat_bubble_sent"
    static let IMG_CHAT_BUBBLE_RECEIVED = "chat_bubble_received"
    static let PANIC_TITLE = "Panic"
    static let STATUS_VC_NAME = "StatusViewController"
    static let MESSAGE_KEY_ORIGIN = "origin"
    static let MESSAGE_KEY_DESTINY = "destiny"
    static let MESSAGE_KEY_TEXT = "text"
    static let MESSAGE_VAL_TEXT = "inititating chat"
    static let MESSAGE_KEY_STATUS = "status"
    static let NEW_CHAT_KEYPATH = "newChat"
    static let KEY_OTO_CHANNEL = "OTOChannel"
    static let SEND = "send"
    static let RECEIVE = "Receive"
    static let CREATION_DATE = "creationDate"
    static let SECTION_CELL = "sectionCell"
    static let YESTERDAY = "YESTERDAY"
    static let TODAY = "TODAY"
    
    //MARK: StatusViewController
    static let STATUS_VC_TITLE = "Delay Code"
    static let IMG_NOT_FOUND = "noImageFound"
    
    //MARK: ObjectExtension
    static let SERVER_NOT_ANSWER = "Server is currently offline.\nRetry or contact Admin"
    static let NO_INTERNET_ALERT_MESSAGE = "Wifi connection not found,\nReturn to campus \n Or contact Admin"
    static let EXPIRED_SESSION_MESSAGE = "Your session has expired\nPlease login"
    static let GENERAL_ERROR_TITLE = "Unhandled error"
    static let GENERAL_ERROR_MESSAGE = "An unexpected error\nRetry or contact Admin"
    
    //MARK: APIManager
    static let LOGIN_TEXT = "Login"
    static let MESSAGES_KEYPATH = "messages"
    static let FEATURES_KEYPATH = "features"
    static let NAVIGATIONBAR_COLOR : UIColor = UIColor(red: 40/255, green: 67/255, blue: 163/255, alpha: 1);
    static let NOVATRACK   = "Novatrack"
    static let NAVVTRACK   = "NavvTrack"
    static let FONT_SF_Display_Bold = "SF-Pro-Display-Bold.otf"
    static let MENU_IMAGE = UIImage(named: "menu")
    static let SUCCESS_MSG = "message success"
    static let ERROR_MSG = "message error:"
    static let isnstall =  "choc"
    static var alertExpired: UIAlertController? = nil
    
    static let INVALID_DEFAULT_PHONE_ID = "402951"
    
    
    static let stagingSSID = "ITEXICO"
    
    //MARK: IMDF
    static let VENUE = "venues"
    static let LEVELS = "levels"
    static let UNITS = "units"
    static let OPENINGS = "openings"
}
