//
//  MapViewController.swift
//  hfciPatientX
//
//  Created by developer on 15/09/21.
//

import UIKit
import DropDown
import Mappedin
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var artWalkContainerView: UIView!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var goToArtwalkButton: UIButton!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var locationData: UITableView!
    @IBOutlet weak var directionsData: UITableView!
    
    @IBOutlet weak var exploreView: RoundedButtonView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var directionsView: RoundedView!
    
    @IBOutlet weak var directionsController: RoundedButtonView!
    
    @IBOutlet weak var textDirectionsBTN: UIButton!
    
    var mapMpiView: MPIMapView!
    var mapFroors: [MPIMap] = []
    var allLocations : [MPILocation] = []
    var filteredPolygonLocations : [MPILocation] = []
    var nodeLocations : [MPILocation] = []
    var instructions : [String] = []
    var direction : MPIDirections!
    var point1 : MPILocation!
    var point2 : MPILocation!
    var nearestNode : MPINode!
    var ontrack = false
    var lastFloor = ""
    var didFinishLoadingMap: (()->())?
    var didRangedBeacons: (()->Void)?
   // var beacon: Beacon?
    var painting: Painting?
    var paintingDetailViewController: PaintingDetailViewController?
    @IBOutlet weak var fromWhereView: UIView!
    
    @IBOutlet weak var selectDropdown: UIView!
    @IBOutlet weak var placeOption: UILabel!
    
    @IBOutlet weak var close: UIImageView!
    
    @IBOutlet weak var controlls: UIView!
    
    @IBOutlet weak var floorSelector: UIView!
    @IBOutlet weak var floorLBL: UILabel!
    
    @IBOutlet weak var fromViewSelect: UIView!
    @IBOutlet weak var toViewSelect: UIView!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var tolbl: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func goBack(_ sender: Any) {
        directionsView.isHidden = true
        controlls.isHidden = false
        fromWhereView.isHidden = true
        directionsData.isHidden = true
        titleLbl.text = "Points of Interest"
        self.nodeLocations = self.allLocations.filter { location in
            location.nodes!.count > 0
        }
        self.locationData.reloadData()
        point1 = nil
        point2 = nil
        tolbl.text = "Destination?"
        fromLbl.text = "Your Location"
        placeOption.text = "Your Location"
        mapMpiView.journeyManager.clear()
        ontrack = false
    }
    
    func showGoToArtwalkButton(isHidden: Bool) {
        self.goToArtwalkButton.isHidden = isHidden
    }
    
    func getLocationWithBeacon(beacon: Beacon) -> MPILocation? {
        let locations = self.allLocations.filter { location in
            location.name == beacon.paintings.first?.location
        }
        if locations.count > 0 {
            if let found = locations.first {
                return found
            }
        }
        
        return nil
    }
    
    func getLocationWithPainting(painting: Painting) -> MPILocation? {
        let locations = self.allLocations.filter { location in
            location.name == painting.location
        }
        if locations.count > 0 {
            if let found = locations.first {
                return found
            }
        }
        
        return nil
    }
    
    @IBAction func goToArtWalkPaintingAction(_ sender: Any) {
       guard let paint = self.painting else { return }
        guard let location = getLocationWithPainting(painting: paint) else { return }

        self.getDirectionsTo(location: location) { directionsInstructions in
            print(directionsInstructions)
            
           let directionsString = directionsInstructions.instructions.map { instruction in
                                return instruction.instruction ?? "Unknown"
            }

            self.paintingDetailViewController?.pushDirectionsView(directionsString: directionsString)

        }
        
        
    }
    
    //From dropdown inside the view after you select a point in the table, you need all the points in the map that have nodes
    var selectMenu : DropDown = {
        let menu = DropDown()
        return menu
    }()
    //From dropdown inside the map view after you got directions, you need all the points in the map that have nodes
    var fromSelect : DropDown = {
        let menu = DropDown()
        return menu
    }()
    //To dropdown inside the view after you got directions, you need all the points in the map that have polygons
    var toSelect : DropDown = {
        let menu = DropDown()
        return menu
    }()
    //Floor or map colections
    var floorSelect : DropDown = {
        let menu = DropDown()
        return menu
    }()
    
    @IBAction func routing(_ sender: Any) {
        if(point1 != nil) {
            controlls.isHidden = true
            directionsView.isHidden = false
            fromLbl.text = point1.name
            tolbl.text = point2.name
            mapMpiView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            getDirection()
        }else if(nearestNode != nil){
            controlls.isHidden = true
            directionsView.isHidden = false
            fromLbl.text = "Your Location"
            tolbl.text = point2.name
            mapMpiView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            getDirection()
        }
    }
    
    @IBAction func showTextDirections(_ sender: Any) {
        self.directionsData.isHidden = false
        self.textDirectionsBTN.titleLabel?.text = "Hide Text Directions"
    }
    
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.goToArtwalkButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(didRangePainting), name: Notification.Name("didRangedPainting"), object: nil)
        
        // Do any additional setup after loading the view.
        self.setupLocationManager()

        self.directionsView.isHidden = true
        self.fromWhereView.isHidden = true
           // Set up MPIMapView and add to view
        self.goToArtwalkButton.layer.cornerRadius = 10
        floorSelector.layer.cornerRadius = 10
        floorSelector.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        mapMpiView = MPIMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        self.mapView.addSubview(mapMpiView)
        if let mapView = mapMpiView {
            mapView.loadVenue(
                options: MPIOptions.Init(
                  clientId: "601c2371fac662001be42493",
                  clientSecret: "raW1AeQ5WikKMflCbX5GAozTA0kcGsgl99HUIJHr1B6wwgoG",
                  venue: "henry-ford-cancer-center"
                ),
                showVenueOptions: MPIOptions.ShowVenue(labelAllLocationsOnInit: true, backgroundColor: "#ffffff")
              )
            }
                

        self.mapMpiView.delegate = self
        self.mapMpiView.blueDotManager.enable(options: .init(allowImplicitFloorLevel: false, smoothing: false, showBearing: false, baseColor: "#ffffff"))
        self.locationData.delegate = self
        self.locationData.dataSource = self
        self.locationData.rowHeight = 80.0
        self.directionsData.delegate = self
        self.directionsData.dataSource = self
        self.directionsData.rowHeight = 80.0
        self.directionsData.isHidden = true
        self.searchBar.delegate = self
        registerTableViewCells()
        
        
        let closeFrom = UITapGestureRecognizer(target: self, action: #selector(didClose))
        closeFrom.numberOfTapsRequired = 1
        closeFrom.numberOfTouchesRequired = 1
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(closeFrom)
        
        
        let exploreGesture = UITapGestureRecognizer(target: self, action: #selector(explore))
        exploreGesture.numberOfTapsRequired = 1
        exploreGesture.numberOfTouchesRequired = 1
        exploreView.isUserInteractionEnabled = true
        exploreView.addGestureRecognizer(exploreGesture)
        
        let directionsGesture = UITapGestureRecognizer(target: self, action: #selector(directions))
        directionsGesture.numberOfTapsRequired = 1
        directionsGesture.numberOfTouchesRequired = 1
        directionsController.isUserInteractionEnabled = true
        directionsController.addGestureRecognizer(directionsGesture)
        
        titleLbl.text = "Points of Interest"
        
        selectMenu.anchorView = selectDropdown
        selectMenu.selectionAction = { index, title in
            self.placeOption.text = title
            self.point1 = self.nodeLocations[index]
        }
        
        fromSelect.anchorView = fromViewSelect
        fromSelect.selectionAction = { index, title in
            self.fromLbl.text = title
            self.point1 = self.nodeLocations[index]
            if(self.point2 != nil){
                self.getDirection()
            }
        }
        
        toSelect.anchorView = toViewSelect
        toSelect.selectionAction = { index, title in
            self.tolbl.text = title
            self.point2 = self.nodeLocations[index]
            self.getDirection()
        }
        
        floorSelect.anchorView = floorSelector
        floorSelect.selectionAction = { index, title in
            self.selectMap(index: index, title: title)
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        selectDropdown.addGestureRecognizer(gesture)
        
        let fromGesture = UITapGestureRecognizer(target: self, action: #selector(newFrom))
        fromGesture.numberOfTapsRequired = 1
        fromGesture.numberOfTouchesRequired = 1
        fromViewSelect.addGestureRecognizer(fromGesture)
        
        let toGesture = UITapGestureRecognizer(target: self, action: #selector(newTo))
        toGesture.numberOfTapsRequired = 1
        toGesture.numberOfTouchesRequired = 1
        toViewSelect.addGestureRecognizer(toGesture)
        
        let floorGesture = UITapGestureRecognizer(target: self, action: #selector(newMap))
        floorGesture.numberOfTapsRequired = 1
        floorGesture.numberOfTouchesRequired = 1
        floorSelector.addGestureRecognizer(floorGesture)
        
        artWalkContainerView.frame = CGRect(x: 0, y: 0, width: 300, height: self.view.frame.height - 90)
        controlls.isHidden = false
        artWalkContainerView.isHidden = true


    }
    
    
    
    func guidedArtWalkFromCurrentLocation() {
        
        
//        guard let nearest = self.nearestNode else { return }
//
//        guard let paint = self.painting else { return }
//         guard let location = getLocationWithPainting(painting: paint) else { return }
        
        var locations: MPINode
        if let nearest = self.nearestNode {
            locations = nearest
        } else {
            
            if let entrance = getEntrance(allLocation: self.allLocations) {
                guard let loc = entrance.nodes?.first else { return }
                locations = loc
            } else {
                return
            }
            
        }
        
        
        
        var locationsArtWalk: [MPILocation] = []
                
        let allPaitingLocations = paintings.map { painting in
            return painting.location
        }
    
        for locationString in allPaitingLocations {
            for location in self.allLocations {
                if location.name == locationString {
                    locationsArtWalk.append(location)
                }
            }
        }
        
        
        
        self.mapMpiView.getDirections(to: MPIDestinationSet(destinations: locationsArtWalk), from: locations, accessible: true) { directions in
            if let directionsInstructions = directions {

//                let nodes = directionsInstructions.map { direction in
//                    direction.p
//                }
                
                self.mapMpiView.journeyManager.draw(directions: directionsInstructions, options: MPIOptions.Journey(
                    pathOptions: MPIOptions.Path(color: "#F44F36", pulseColor: "#000000", displayArrowsOnPath: true)))
              ////  self.mapMpiView.drawPath(path: directionsInstructions, pathOptions: MPIOptions.Journey(
                 //   pathOptions: MPIOptions.Path(color: "#F44F36", pulseColor: "#000000", displayArrowsOnPath: true)))
//                self.mapMpiView?.drawJourney(
//                    directions: directionsInstructions,
//                    options: MPIOptions.Journey(
//                        pathOptions: MPIOptions.Path(color: "#F44F36", pulseColor: "#000000", displayArrowsOnPath: true)))
                
//                self.mapMpiView?.focusOn(focusOptions: MPIOptions.Focus(nodes: location.nodes, polygons: location.polygons, duration: 0.2, changeZoom: true, minZoom: 0.4, tilt: 0.2, padding: .none, focusZoomFactor: 0.2))
        }
        }
    }
    
    func getDirectionsTo(location: MPILocation, directionsInstructions: @escaping ((_ directionsInstructions: MPIDirections) -> Void)) {
        
        var locations: MPINode
        if let nearest = self.nearestNode {
            locations = nearest
        } else {
            
            if let entrance = getEntrance(allLocation: self.allLocations) {
                guard let loc = entrance.nodes?.first else { return }
                locations = loc
            } else {
                return
            }
            
        }
    
        // Get directions to selected polygon from users nearest node
        self.mapMpiView?.getDirections(to: location, from: locations, accessible: true) { directions in
            // remove custom markers before calling drawJourney
//            if let markerId = self.presentMarkerId {
//                self.mapView?.removeMarker(id: markerId)
//            }
            if let directions = directions {
                self.mapMpiView?.focusOn(focusOptions: MPIOptions.Focus(nodes: [locations], polygons: [], duration: 0.2, changeZoom: true, minZoom: 0.4, tilt: 0.2, padding: .none, focusZoomFactor: 0.2))
                self.mapMpiView?.drawJourney(
                    directions: directions,
                    options: MPIOptions.Journey(
                        pathOptions: MPIOptions.Path(color: "#F44F36", pulseColor: "#000000", displayArrowsOnPath: true)))
               // self.direction = directions
//                self.instructions = self.direction.instructions.map { instruction in
//                    return instruction.instruction ?? "Unknown"
//                }
                
                directionsInstructions(directions)
                
                
            }
        }
    }
    
    func getDirecctionsData(completion: ()->()) {
        
    }
    
    @objc func didRangePainting(notification: Notification) {
        
        if SessionManager.shared.isArtWalkModeSelected == false { return }
        print("👗")
        print(notification.object ?? "") //myObject
        print(notification.userInfo ?? "") //[AnyHashable("key"): "Value"]
        if let beaconRanged = notification.object as? Beacon {
           // Alerts.displayAlert(with: "beacon", and: "\(beaconRanged.paintings[0].title)")
           // Alerts.displayAlertPainting(painting: beaconRanged.paintings[0])
            
            if beaconRanged.paintings.count == 1 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let paintingBeaconViewcontroller = storyboard.instantiateViewController(withIdentifier: "PaintingBeaconViewController") as? PaintingBeaconViewController else { return }
                
                paintingBeaconViewcontroller.painting = beaconRanged.paintings[0]
                paintingBeaconViewcontroller.didPressYes = { painting in
                    
                    
                    
                    guard let beacon = painting.beacon else { return }
                    guard let location = self.getLocationWithBeacon(beacon: beacon) else { return }
                   
                    
                    self.getDirectionsTo(location: location) { directionsInstructions in
                        print(directionsInstructions)
                        
                       let directionsString = directionsInstructions.instructions.map { instruction in
                                            return instruction.instruction ?? "Unknown"
                        }

                     //   self.paintingDetailViewController?.pushDirectionsView(directionsString: directionsString)
                        //self.galleryNavigationController?.pushViewController(paintingBeaconViewcontroller, animated: true)
                        
                        guard let paintingDetailViewController = storyboard.instantiateViewController(withIdentifier: "PaintingDetailViewController") as? PaintingDetailViewController else { return }
                        self.galleryNavigationController?.pushViewController(paintingDetailViewController, animated: true)
                        paintingDetailViewController.pushDirectionsView(directionsString: directionsString)
                        paintingDetailViewController.painting = beacon.paintings.first
                        paintingDetailViewController.mapViewController = self
                    }
                    
                }
                paintingBeaconViewcontroller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                paintingBeaconViewcontroller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
              //  self.present(paintingBeaconViewcontroller, animated: true, completion: nil)
              //  self.galleryNavigationController?.pushViewController(paintingBeaconViewcontroller, animated: true)

                
            } else if beaconRanged.paintings.count > 1 {
              //  Alerts.displayAlert(with: "More Paitning", and: "x x x")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let groupViewController = storyboard.instantiateViewController(withIdentifier: "GroupViewController") as? GroupViewController else { return }
                groupViewController.beacon = beaconRanged
                groupViewController.mapViewController = self
                self.galleryNavigationController?.pushViewController(groupViewController, animated: true)
            }
            //...
//            var rootViewController = UIApplication.shared.keyWindow?.rootViewController
//            if let navigationController = rootViewController as? UINavigationController {
//                rootViewController = navigationController.viewControllers.first
//            }
//            if let tabBarController = rootViewController as? UITabBarController {
//                rootViewController = tabBarController.selectedViewController
//            }
//            //...
          
        }
      
    }
  
    
    @objc func didTap() {
        selectMenu.show()
    }
    
    @objc func newFrom() {
        fromSelect.show()
    }
    
    @objc func newTo() {
        toSelect.show()
    }
    
    @objc func newMap() {
        floorSelect.show()
    }
    
    @objc func didClose() {
        fromWhereView.isHidden = true
    }
    
    func selectMap(index: Int, title: String) {
        self.floorLBL.text = title
        if let selectedMap = self.mapMpiView?.venueData?.maps[index] {
            self.mapMpiView?.setMap(map: selectedMap)
        }
    }
    
    func labelString(option: String) -> String {
        switch option {
        case "Level 1":
            return "L1"
        case "Level -1":
            return "B"
        case "Level 2":
            return "L2"
        case "Level 3":
            return "L3"
        case "Level 4":
            return "L4"
        case "Level 5":
            return "L5"
        default:
            return "L"
        }
    }
    
    func imageForDirection(option: String) -> UIImage {
        
        if (option.range(of: "Turn right", options: .caseInsensitive, range: nil, locale: nil) != nil) {
            return UIImage(named: "turnRight") ?? UIImage()
        }
        if (option.range(of: "Turn left", options: .caseInsensitive, range: nil, locale: nil) != nil) {
            return UIImage(named: "turnLeft") ?? UIImage()
        }
        if (option.range(of: "Arrive", options: .caseInsensitive, range: nil, locale: nil) != nil) {
            return UIImage(named: "arrived") ?? UIImage()
        }
        if (option.range(of: "Stairs", options: .caseInsensitive, range: nil, locale: nil) != nil) {
            return UIImage(named: "stairs") ?? UIImage()
        }
        if (option.range(of: "Elevator", options: .caseInsensitive, range: nil, locale: nil) != nil) {
            return UIImage(named: "elevator") ?? UIImage()
        }
        if (option.range(of: "Turn slightly right", options: .caseInsensitive, range: nil, locale: nil) != nil) {
            return UIImage(named: "turnSlightlyRigth") ?? UIImage()
        }
        if (option.range(of: "Turn slightly left", options: .caseInsensitive, range: nil, locale: nil) != nil) {
            return UIImage(named: "turnSlightlyLeft") ?? UIImage()
        }
        if (option.range(of: "Go", options: .caseInsensitive, range: nil, locale: nil) != nil) {
            return UIImage(named: "go") ?? UIImage()
        }
        
        return UIImage(named: "myLocation") ?? UIImage()
    }
    
    private func registerTableViewCells() {
        let cell1 = UINib(nibName: "PointCellTableViewCell", bundle: nil)
        self.locationData.register(cell1, forCellReuseIdentifier: "PointCellTableViewCell")
        
        let cell2 = UINib(nibName: "DirectionsTableViewCell", bundle: nil)
        self.directionsData.register(cell2, forCellReuseIdentifier: "DirectionsTableViewCell")
    }
    
    private func getFileContentFromBundle(forResource: String, ofType: String) -> String? {
        guard let path = Bundle.main.path(forResource: forResource, ofType: ofType) else { return nil }
        return try? String(contentsOfFile: path)
    }
    
    @objc func action() {
        view.endEditing(true)
    }
    
    @objc func explore() {
        self.nodeLocations = self.allLocations.filter { location in
            location.type == "amenities" && location.polygons!.count > 0
        }
        
        filteredPolygonLocations = nodeLocations
        
        self.locationData.reloadData()
        
        titleLbl.text = "Amenities"
    }
    
    @objc func directions() {
        self.controlls.isHidden = true
        self.directionsView.isHidden = false
    }
    
    func filterLocations() {
        self.nodeLocations = self.allLocations.filter { location in
            location.nodes!.count > 0
        }
        
        filteredPolygonLocations = nodeLocations
        
        selectMenu.dataSource = self.nodeLocations.map({ location in
            location.name
        })
        
        fromSelect.dataSource = self.nodeLocations.map({ location in
            location.name
        })
        
        toSelect.dataSource = self.nodeLocations.map({ location in
            location.name
        })
    }
    
    func getDirection() {
        if(point1 != nil && (point2.nodes?.count ?? 0) > 0){
            let map = self.mapMpiView.venueData?.maps.first(where: { element in
                element.id == self.point1.nodes?.first?.map ?? ""
            })
            floorLBL.text = labelString(option: map?.name ?? "")
                        
            self.mapMpiView?.getDirections(to: point2.nodes?.first as! MPINavigatable, from: point1.nodes?.first as! MPINavigatable, accessible: true) { directions in
                if let directions = directions {
                    self.mapMpiView.setMap(mapId: self.point1.nodes?.first?.map ?? "", completionCallback: nil)
                    self.mapMpiView.focusOn(focusOptions: MPIOptions.Focus(nodes: self.point1.nodes, polygons: self.point1.polygons, duration: 0.2, changeZoom: true, minZoom: 0.4, tilt: 0.2, padding: .none , focusZoomFactor: 0.2))
                    self.mapMpiView?.drawJourney(
                        directions: directions,
                        options: MPIOptions.Journey(
                            pathOptions: MPIOptions.Path(color: "#F44F36", pulseColor: "#000000", displayArrowsOnPath: true)
                        )
//                        options: MPIOptions.Journey(connectionTemplateString: """
//                                                        <div style="font-size: 13px; display: flex; align-items: center; justify-content: center;">
//                                                        <div style="margin: 10px;">{{capitalize type}} {{#if isEntering}}to{{else}}from{{/if}} {{toMapName}}</div>
//                                                        <div style="width: 40px; height: 40px; border-radius: 50%;background: green; display: flex; align-items: center; margin: 5px; margin-left: 0px; justify-content: center;">
//                                                            <svg height="16" viewBox="0 0 36 36" width="16">
//                                                                <g fill="white">{{{icon}}}</g>
//                                                            </svg>
//                                                        </div>
//                                                    </div>
//                                                    """
//                                                    , destinationMarkerTemplateString: """
//                                                        <div style="width: 32px; height: 32px;">
//                                                        <svg width="12cm" height="4cm" viewBox="0 0 1200 400"
//                                                             xmlns="http://www.w3.org/2000/svg" version="1.1">
//                                                          <desc>Example circle01 - circle filled with red and stroked with blue</desc>
//
//                                                          <!-- Show outline of viewport using 'rect' element -->
//                                                          <rect x="1" y="1" width="1198" height="398"
//                                                                fill="none" stroke="blue" stroke-width="2"/>
//
//                                                          <circle cx="600" cy="200" r="100"
//                                                                fill="red" stroke="blue" stroke-width="10"  />
//                                                        </svg>
//                                                        </div>
//                                                    """
//                                                    , departureMarkerTemplateString: """
//                                                        <div style="width: 32px; height: 32px;">
//                                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 293.334 293.334">
//                                                            <g fill="#010002">
//                                                                <path d="M146.667 0C94.903 0 52.946 41.957 52.946 93.721c0 22.322 7.849 42.789 20.891 58.878 4.204 5.178 11.237 13.331 14.903 18.906 21.109 32.069
//                                                                    48.19 78.643 56.082 116.864 1.354 6.527 2.986 6.641 4.743.212 5.629-20.609 20.228-65.639 50.377-112.757 3.595-5.619 10.884-13.483 15.409-18.379a94.561
//                                                                    94.561 0 0016.154-24.084c5.651-12.086 8.882-25.466 8.882-39.629C240.387 41.962 198.43 0 146.667 0zm0 144.358c-28.892 0-52.313-23.421-52.313-52.313 0-28.887
//                                                                    23.421-52.307 52.313-52.307s52.313 23.421 52.313 52.307c0 28.893-23.421 52.313-52.313 52.313z"/>
//                                                                <circle cx="146.667" cy="90.196" r="21.756"/>
//                                                            </g>
//                                                        </svg>
//                                                        </div>
//                                                    """
//                                                    , pathOptions: MPIOptions.Path(color: "#F44F36", pulseColor: "#000000", displayArrowsOnPath: true), polygonHighlightColor: "orange")
                   )
                    self.direction = directions
                    self.instructions = self.direction.instructions.map { instruction in
                        return instruction.instruction ?? "Unknown"
                    }
                    self.directionsData.reloadData()
                    self.ontrack = true
                    
                    //MPIOptions.Journey(
                        //pathOptions: MPIOptions.Path(color: "#F44F36", pulseColor: "#000000", displayArrowsOnPath: true)
                        //)
                }
            }
            
        }else if(nearestNode != nil && (point2.nodes?.count ?? 0) > 0){
            let map = self.mapMpiView.venueData?.maps.first(where: { element in
                element.id == nearestNode?.map ?? ""
            })
            floorLBL.text = labelString(option: map?.name ?? "")
                        
            self.mapMpiView?.getDirections(to: point2.nodes?.first as! MPINavigatable, from: nearestNode as! MPINavigatable, accessible: true) { directions in
                if let directions = directions {
                    self.mapMpiView.setMap(mapId: self.nearestNode.map ?? "", completionCallback: nil)
                    self.mapMpiView.focusOn(focusOptions: MPIOptions.Focus(nodes: [self.nearestNode], polygons: [], duration: 0.2, changeZoom: true, minZoom: 0.4, tilt: 0.2, padding: .none , focusZoomFactor: 0.2))
                    self.mapMpiView?.drawJourney(
                        directions: directions,
                        options: MPIOptions.Journey(
                            pathOptions: MPIOptions.Path(color: "#F44F36", pulseColor: "#000000", displayArrowsOnPath: true)
                        )
                    )
                    self.direction = directions
                    self.instructions = self.direction.instructions.map { instruction in
                        return instruction.instruction ?? "Unknown"
                    }
                    self.directionsData.reloadData()
                    self.ontrack = true
                }
            }
        }
    }
    
    func getFloorOfPlace(location: MPILocation){
        print(location.parent ?? "")
        print(location.nodes?.first?.map ?? "")
    }
    
    func setupLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
            
            let center = CLLocationCoordinate2D(latitude: 22.425118, longitude: 114.239927)
            let radius = 100.0 // 100m
            let region = CLCircularRegion(center: center, radius: radius, identifier: "fooIdentifier")

            // Notified when user enter the region; Callback locationManager:didExitRegion:
            region.notifyOnEntry = true

            // Notified when user leaves the region; Callback locationManager:didEnterRegion:
            region.notifyOnExit = true

             self.locationManager.startMonitoring(for: region)
           // startScanning()

            
        }

    }
    
    var galleryViewController : GalleryViewController?
    var galleryNavigationController: UINavigationController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navForArtWalk" {
            if let navigationController = segue.destination as? UINavigationController {
                galleryNavigationController = navigationController
                if let galleryViewController = navigationController.viewControllers.first as? GalleryViewController {
                    self.galleryViewController = galleryViewController
                    self.galleryViewController?.mapViewController = self
                }
            }
        }
    }
   
}

extension MapViewController: MPIMapViewDelegate {
    func onBlueDotPositionUpdate(update: MPIBlueDotPositionUpdate) {
        // Called when the blueDot that tracks the user position is updated
        self.nearestNode = update.nearestNode
        print(self.nearestNode.debugDescription)
        let map = self.mapMpiView.venueData?.maps.first(where: { element in
            element.id == update.nearestNode?.map ?? ""
        })
        
        if(lastFloor != map?.name){
            lastFloor = map?.name ?? ""
            floorLBL.text = labelString(option: map?.name ?? "")
            if(map != nil) {
                self.mapMpiView?.setMap(map: map!)
            }
        }
    }

    func onBlueDotStateChange(stateChange: MPIBlueDotStateChange) {
        // Called when the state of blueDot is changed
    }

    func onMapChanged(map: MPIMap) {
    }

    func onPolygonClicked(polygon: MPIPolygon) {
        // Called when the polygon is clicked
//        self.mapMpiView.focusOn(focusOptions: MPIOptions.Focus(nodes: polygon.locations?.first?.nodes, polygons: [polygon], duration: 0.2, changeZoom: true, minZoom: 0.4, tilt: 0.2, padding: .none , focusZoomFactor: 0.2))
//        point2 = polygon.locations?.first
//        tolbl.text = polygon.locations?.first?.name ?? "Unknown"
    }

    func onNothingClicked() {
        // Called when a tap doesn't hit any spaces
    }


    @available(*, deprecated, message: "use onBlueDotPositionUpdate and onBlueDotStateChange")
    func onBlueDotUpdated(blueDot: MPIBlueDot) {
        //let nearestNode = blueDot.nearestNode
       // self.mapMpiView.createMarker(node: nearestNode, contentHtml: markerString ?? "")


    }

    func onDataLoaded(data: MPIData) {
        // Called when the mapView has finished loading both the view and venue data
        self.didFinishLoadingMap?()
      
    }

    func onFirstMapLoaded() {
        // Called when the first map is fully loaded
        self.allLocations = mapMpiView.venueData?.locations ?? []
        if let gallery = self.galleryViewController {
            gallery.allLocations = self.allLocations
            gallery.setAllLocations()
        }
        self.filterLocations()
        
        floorSelect.dataSource = mapMpiView?.venueData?.maps.map({ mapElement in
            labelString(option: mapElement.name)
        }) ?? []
        floorLBL.text = labelString(option: mapMpiView?.venueData?.maps.first?.name ?? "")
        
        self.locationData.reloadData()
        
        mapMpiView.blueDotManager.enable(options: MPIOptions.BlueDot(
            allowImplicitFloorLevel: true, smoothing: false, showBearing: true, baseColor: "#2266ff"
        ))
        
    }

    func onStateChanged (state: MPIState) {
        // Called when the state of the map has changed
    }
    
}

extension MapViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == locationData){
            let data = self.filteredPolygonLocations[indexPath.row]
            
            if ((data.polygons?.count) != nil) {
                point2 =  self.filteredPolygonLocations[indexPath.row]
                self.fromWhereView.isHidden = false
            }
            
            if data.nodes!.count > 0 {
                let map = self.mapMpiView.venueData?.maps.first(where: { element in
                    element.id == self.point2.nodes?.first?.map ?? ""
                })
                floorLBL.text = labelString(option: map?.name ?? "")
                self.mapMpiView.setMap(mapId: self.point2.nodes?.first?.map ?? "", completionCallback: nil)
                self.mapMpiView.focusOn(focusOptions: MPIOptions.Focus(nodes: self.point2.nodes, polygons: self.point2.polygons, duration: 0.2, changeZoom: true, minZoom: 0.4, tilt: 0.2, padding: .none , focusZoomFactor: 0.2))
            }
        }
    }
}

extension MapViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == locationData ? self.filteredPolygonLocations.count : self.instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == locationData) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PointCellTableViewCell") as? PointCellTableViewCell {
                let data = self.filteredPolygonLocations[indexPath.row]
                cell.locationDesc.text = data.name
                cell.floor.text = self.mapMpiView.venueData?.maps.first(where: { element in
                    element.id == data.nodes?.first?.map ?? ""
                })?.name ?? "Unknown"
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionsTableViewCell") as? DirectionsTableViewCell {
                let data = self.instructions[indexPath.row]
                cell.directionImage.image = imageForDirection(option: data)
                cell.directionLBL.text = data
                return cell
            }
        }
            
        return UITableViewCell()
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // When there is no text, filteredData is the same as the original data
            // When user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredPolygonLocations = searchText.isEmpty ? nodeLocations : nodeLocations.filter { (item: MPILocation) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            
            locationData.reloadData()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let dateTime = Date()
            print("❌ \(location)")
            let coordinates = MPICoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, accuracy: 0.8, floorLevel: location.floor?.level)
            self.mapMpiView.blueDotManager.updatePosition(position: MPIPosition(timestamp: dateTime.timeIntervalSince1970, coords: coordinates, type: "", annotation: ""))
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == CLAuthorizationStatus.authorized {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                   // startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("⚠️ \(beacons)")
        
        for beacon in beacons {
            
            if let foundedBeacon = getBeaconByMayorAndMinor(mayor: beacon.major.intValue, minor: beacon.minor.intValue) {
           // foundedBeacon.proximity = 0
            foundedBeacon.rrsi = beacon.rssi
            foundedBeacon.timeStamp = beacon.timestamp
            let beaconString = "\(beacon)"
            let splitInQoutes = beaconString.split(separator: ",")[3]
            let splitInTwoPoints = splitInQoutes.split(separator: ":")[1]
            let distance = splitInTwoPoints.split(separator: " ")[2]
            let rawDistance = distance.replacingOccurrences(of: "m", with: "")
            let proximity = Double(String(rawDistance)) ?? 0
            foundedBeacon.proximity = proximity
            foundedBeacon.clproximity = beacon.proximity
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name("didRangeBeacons"), object: beacons)
       // self.didRangedBeacons?()
        
    }
}

extension MapViewController {
    func startScanning() {
        let uuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "painting")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
//        let uuid2 = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!
//        let beaconRegion2 = CLBeaconRegion(uuid: uuid, major: 20545, minor: 5125, identifier: "Painting 2")
//        locationManager.startMonitoring(for: beaconRegion2)
//        locationManager.startRangingBeacons(in: beaconRegion2)
        
        
    }
    
    func stopScanning() {
        let uuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "painting")
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
        
//        let uuid2 = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!
//        let beaconRegion2 = CLBeaconRegion(uuid: uuid, major: 20545, minor: 5125, identifier: "Painting 2")
//        locationManager.startMonitoring(for: beaconRegion2)
//        locationManager.startRangingBeacons(in: beaconRegion2)
        
        
    }
}
