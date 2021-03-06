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
import WebKit

class MapViewController: UIViewController {

    @IBOutlet weak var artWalkContainerView: UIView!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var goToArtwalkButton: UIButton!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var locationData: UITableView!
    @IBOutlet weak var directionsData: UITableView!
        
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var directionsView: RoundedView!
        
    @IBOutlet weak var textDirectionsBTN: UIButton!
    
    @IBOutlet weak var endTourBtn: UIButton!
    
    var mapMpiView: MPIMapView!
    var mapFroors: [MPIMap] = []
    var allLocations : [MPILocation] = []
    var visitedPaints : [String] = []
    var filteredPolygonLocations : [MPILocation] = []
    var nodeLocations : [MPILocation] = []
    var instructions : [String] = []
    var direction : MPIDirections!
    var point1 : MPILocation!
    var point2 : MPILocation!
    var nearestNode : MPINode!
    var lastFloor = ""
    var didFinishLoadingMap: (()->())?
    var didRangedBeacons: (()->Void)?
    var painting: Painting?
    var paintingDetailViewController: PaintingDetailViewController?
    var tourPaintingDetailViewController : TourPaintingDetailViewController?
    var previousPaintingDetailViewController : PreviousPaintingDetailViewController?
    let centerButton = UIButton(type: .custom)
    var gidedArtTour : Bool = false
    
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
        centerButton.isHidden = true
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
        mapMpiView.blueDotManager.setState(state: .EXPLORE)
        mapMpiView.journeyManager.clear()
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
            self.mapMpiView.blueDotManager.setState(state: .FOLLOW)
            self.centerButton.isHidden = false
           let directionsString = directionsInstructions.instructions.map { instruction in
                                return instruction.instruction ?? "Unknown"
            }
            self.startScanningPainting(painting: paint)
            if(self.gidedArtTour){
                self.tourPaintingDetailViewController?.pushDirectionsView(directionsString: directionsString, fromMenu: self.fromSelect, toMenu: self.toSelect)
            }else{
                self.paintingDetailViewController?.pushDirectionsView(directionsString: directionsString, fromMenu: self.fromSelect, toMenu: self.toSelect)
            }
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
            getDirection()
        }else if(nearestNode != nil){
            controlls.isHidden = true
            directionsView.isHidden = false
            fromLbl.text = "Your Location"
            tolbl.text = point2.name
            getDirection()
        }
    }
    
    @IBAction func showTextDirections(_ sender: Any) {
        self.directionsData.isHidden = false
        self.textDirectionsBTN.titleLabel?.text = "Hide Text Directions"
        if let galleryViewController = navigationController?.viewControllers.first as? GalleryViewController {
            self.galleryViewController = galleryViewController
            self.galleryViewController?.mapViewController = self
        }
    }
    
    
    @IBAction func endTour(_ sender: Any) {
        gidedArtTour = false
        endTourBtn.isHidden = true
        self.visitedPaints = []
        galleryViewController?.endTour()
        self.goToArtwalkButton.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("endGuidedTour"), object: nil)
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

        self.endTourBtn.layer.cornerRadius = 10
        
        floorSelector.layer.cornerRadius = 10
        floorSelector.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        mapMpiView = MPIMapView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.height, height: self.mapView.frame.width))
        
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
                
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

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
                
        titleLbl.text = "Points of Interest"
        
        selectMenu.anchorView = selectDropdown
        selectMenu.selectionAction = { index, title in
            self.placeOption.text = title
            self.point1 = title == "Your Location" ? nil : self.nodeLocations.filter{$0.name == title}.first
        }
        
        fromSelect.anchorView = fromViewSelect
        fromSelect.selectionAction = { index, title in
            self.fromLbl.text = title
            self.point1 = title == "Your Location" ? nil : self.nodeLocations.filter{$0.name == title}.first
            if(self.point2 != nil){
                self.getDirection()
            }
        }
        
        toSelect.anchorView = toViewSelect
        toSelect.selectionAction = { index, title in
            self.tolbl.text = title
            self.point2 = self.nodeLocations.filter{$0.name == title}.first
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
        
        centerButton.frame = CGRect(x: self.mapMpiView.frame.width - 80, y: self.mapMpiView.frame.height - 150, width: self.mapMpiView.frame.width/12, height: self.mapMpiView.frame.width/12)
        centerButton.layer.cornerRadius = 0.5 * centerButton.bounds.size.width
        centerButton.clipsToBounds = true
        centerButton.setImage(UIImage(named:"myLocation"), for: .normal)
        centerButton.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        centerButton.isHidden = true
        mapMpiView.addSubview(centerButton)
    }
    
    @objc func thumbsUpButtonPressed() {
        self.mapMpiView.blueDotManager.setState(state: .FOLLOW)
    }
    
    func guidedArtWalk() {
        gidedArtTour = true
        endTourBtn.isHidden = false
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
            if let directions = directions {
                self.mapMpiView?.focusOn(focusOptions: MPIOptions.Focus(nodes: [locations], polygons: [], duration: 1.0, changeZoom: true, minZoom: 1.0, tilt: 0.6, padding: .none, focusZoomFactor: 0.2))
                self.mapMpiView?.drawJourney(
                    directions: directions,
                    options: MPIOptions.Journey(
                        connectionTemplateString: nil,
                        destinationMarkerTemplateString: nil,
                        departureMarkerTemplateString: "",
                        pathOptions: MPIOptions.Path(color: "#F44F36", pulseColor: "#000000", displayArrowsOnPath: true),
                        polygonHighlightColor: "orange")
                )
                
                directionsInstructions(directions)
            }
        }
    }
    
    func getDirecctionsData(completion: ()->()) {
        
    }
    
    @objc func didRangePainting(notification: Notification) {
        
        if SessionManager.shared.isArtWalkModeSelected == false { return }
        print("????")
        print(notification.object ?? "") //myObject
        print(notification.userInfo ?? "") //[AnyHashable("key"): "Value"]
        if let beaconRanged = notification.object as? Beacon {
            
            if beaconRanged.paintings.count == 1 {
                
                guard let bottomBanner = BottomBannerView.instantiate() else { return }
                bottomBanner.frame = CGRect(x: self.mapView.bounds.midX + 10 , y: UIScreen.main.bounds.maxY, width: 600, height: 50)
                bottomBanner.layer.masksToBounds = true
                bottomBanner.titleLabel.attributedText = BottomBannerView.formatLabel(paintTitle: beaconRanged.identifier)
                bottomBanner.layer.cornerRadius = 10
                bottomBanner.titleLabel.layer.cornerRadius = 10
                self.view.addSubview(bottomBanner)
                bottomBanner.show(true)
                
                
                _ = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
                    bottomBanner.show(false)
                    if(self.gidedArtTour){
                        self.galleryNavigationController?.popViewController(animated: false)
                    }else{
                        self.galleryNavigationController?.popViewController(animated: false)
                        self.goBack(self)
                    }
                    beaconRanged.isInDesiredDistance = false
                    beaconRanged.isInDesiredDistanceAndTime = false
                    beaconRanged.firstContact = nil
                    self.stopScanning(painting: nil)
                    
                }
            }
          
        }
      
    }
    
    func nextStop(){
        self.galleryViewController?.nextPainting()
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
        if let selectedMap =  self.mapMpiView?.venueData?.maps.first(where: {$0.name == mapName(option: title)}) {
            self.floorLBL.text = title
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
    
    func mapName(option: String) -> String {
        switch option {
        case "L1":
            return "Level 1"
        case "B":
            return "Level -1"
        case "L2":
            return "Level 2"
        case "L3":
            return "Level 3"
        case "L4":
            return "Level 4"
        case "L5":
            return "Level 5"
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
    
    func filterLocations() {
        self.nodeLocations = self.allLocations.filter { location in
            location.nodes!.count > 0 && location.type != "waypoints"
        }.sorted { ($0.nodes?.first?.map)! <= ($1.nodes?.first?.map)!}
        
        filteredPolygonLocations = nodeLocations
        
        
        var dataSource : [String] = []
        dataSource.append("Your Location")
        dataSource.append(contentsOf: self.nodeLocations.map({ location in
            location.name
        }))
        
        
        
        selectMenu.dataSource = dataSource
        
        fromSelect.dataSource = dataSource
        
        toSelect.dataSource = self.nodeLocations.map({ location in
            location.name
        })
    }
    
    func getDirection() {
        self.mapMpiView.blueDotManager.setState(state: .FOLLOW)
        self.centerButton.isHidden = false
        if(point1 != nil && (point2.nodes?.count ?? 0) > 0){
            let map = self.mapMpiView.venueData?.maps.first(where: { element in
                element.id == self.point1.nodes?.first?.map ?? ""
            })
            floorLBL.text = labelString(option: map?.name ?? "")
                        
            self.mapMpiView?.getDirections(to: point2!, from: point1!, accessible: true) { directions in
                if let directions = directions {
                    self.mapMpiView.setMap(mapId: self.point1.nodes?.first?.map ?? "", completionCallback: nil)
                    self.mapMpiView.focusOn(focusOptions: MPIOptions.Focus(nodes: nil, polygons: nil, duration: 1.0, changeZoom: true, minZoom: 0, tilt: 0.8, padding: .none, focusZoomFactor: 1))
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
                }
            }
            
        }else if(nearestNode != nil && (point2.nodes?.count ?? 0) > 0){
            let map = self.mapMpiView.venueData?.maps.first(where: { element in
                element.id == nearestNode?.map ?? ""
            })
            floorLBL.text = labelString(option: map?.name ?? "")
                        
            self.mapMpiView?.getDirections(to: point2 as! MPINavigatable, from: nearestNode as! MPINavigatable, accessible: true) { directions in
                if let directions = directions {
                    self.mapMpiView.setMap(mapId: self.nearestNode.map ?? "", completionCallback: nil)
                    //self.mapMpiView.focusOn(focusOptions: MPIOptions.Focus(nodes: nil, polygons: nil, duration: 1.0, changeZoom: true, minZoom: 0, tilt: 0.2, padding: .none, focusZoomFactor: 1))
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
        print(map.shortName)
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
        
        self.mapFroors = self.mapMpiView.venueData?.maps.filter { $0.name != "Level -1" } ?? []
    
        if let gallery = self.galleryViewController {
            gallery.allLocations = self.allLocations
            gallery.setAllLocations()
        }
        self.filterLocations()
        
        floorSelect.dataSource = ((mapMpiView?.venueData?.maps.map({ mapElement in
            labelString(option: mapElement.name)
        }) ?? []).filter{ $0 != "B"}).sorted{ $0 > $1 }
        floorLBL.text = labelString(option: mapMpiView?.venueData?.maps.first?.name ?? "")
        
        self.locationData.reloadData()
        
        mapMpiView.blueDotManager.enable(options: MPIOptions.BlueDot(
            allowImplicitFloorLevel: true, smoothing: false, showBearing: true, baseColor: "#2266ff"
        ))
        
        print(mapMpiView.cameraControlsManager.rotation)
        print(mapMpiView.cameraControlsManager.tilt)
        
    }

    func onStateChanged (state: MPIState) {
        // Called when the state of the map has changed
        print(state)
    }
    
}

extension MapViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == locationData){
            let data = self.filteredPolygonLocations.filter{$0.nodes?.first?.map == self.mapFroors[indexPath.section].id}
            
            point2 = data[indexPath.row]
            self.fromWhereView.isHidden = false
            
            if data[indexPath.row].nodes!.count > 0 {
                let map = self.mapMpiView.venueData?.maps.first(where: { element in
                    element.id == self.point2.nodes?.first?.map ?? ""
                })
                floorLBL.text = labelString(option: map?.name ?? "")
                self.mapMpiView.setMap(mapId: self.point2.nodes?.first?.map ?? "", completionCallback: nil)
                self.mapMpiView.focusOn(focusOptions: MPIOptions.Focus(nodes: self.point2.nodes, polygons: self.point2.polygons, duration: 0.2, changeZoom: true, minZoom: 0.1, tilt: 0.6, padding: .none , focusZoomFactor: 0.1))
            }
        }
    }
}

extension MapViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == locationData ? self.filteredPolygonLocations.filter{$0.nodes?.first?.map == self.mapFroors[section].id}.count : self.instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == locationData) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PointCellTableViewCell") as? PointCellTableViewCell {
                let data = self.filteredPolygonLocations.filter{$0.nodes?.first?.map == self.mapFroors[indexPath.section].id}
                cell.locationDesc.text = data[indexPath.row].name
                cell.floor.text = self.mapMpiView.venueData?.maps.first(where: { element in
                    element.id == data[indexPath.row].nodes?.first?.map ?? ""
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView == locationData) {
            return self.mapFroors[section].name
        }else{
            return "Directions"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == locationData) {
            return self.mapFroors.count
        }else{
            return 1
        }
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
            print("??? \(location)")
            let coordinates = MPICoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, accuracy: 0.8, floorLevel: location.floor?.level)
            self.mapMpiView.blueDotManager.updatePosition(position: MPIPosition(timestamp: dateTime.timeIntervalSince1970, coords: coordinates, type: "", annotation: ""))
            
            LocationStreaming.sharedInstance.sendToStream(locations: locations)
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
        print("?????? \(beacons)")
        
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
    func startScanningPainting(painting: Painting?) {
        
        if let paint = painting {
            
            guard let beacon = paint.beacon else { return }
            let uuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!
            let beaconRegion = CLBeaconRegion(uuid: uuid, major: CLBeaconMajorValue(beacon.mayor), minor: CLBeaconMinorValue(beacon.minor), identifier: "painting")
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        } else {
            let uuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!
            let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "painting")
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        }
        
        
    }
    
    func stopScanning(painting: Painting?) {
        
        if let paint = painting {
            
            guard let beacon = paint.beacon else { return }
            let uuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!
            let beaconRegion = CLBeaconRegion(uuid: uuid, major: CLBeaconMajorValue(beacon.mayor), minor: CLBeaconMinorValue(beacon.minor), identifier: "painting")
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
        } else {
            let uuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!
            let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "painting")
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
        }
        
        
    }
}
