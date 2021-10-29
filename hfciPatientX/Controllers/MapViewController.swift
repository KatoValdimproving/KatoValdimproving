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
        mapMpiView.reload()
        ontrack = false
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
        // Do any additional setup after loading the view.
        self.setupLocationManager()

        self.directionsView.isHidden = true
        self.fromWhereView.isHidden = true
           // Set up MPIMapView and add to view
        
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
    
    override func viewDidLayoutSubviews() {
     
    }
    
   func showArtWalk() {
        //guard let galleryViewController = GalleryViewController
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//       // guard  let galleryViewController = storyboard.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController else { return }
//
//        guard  let artWalkNavigationController = storyboard.instantiateViewController(withIdentifier: "ArtWalkNavigationController") as? UINavigationController else { return }
//      // self.artWalkNavigationController = artWalkNavigationController
//       let galleryViewController = artWalkNavigationController.viewControllers.first as? GalleryViewController
//       galleryViewController?.allLocations = self.allLocations
//       // self.chatViewController.willMove(toParent: self)
//        artWalkNavigationController.view.frame = CGRect(x: 0, y: 0, width: self.artWalkContainerView.bounds.width, height: self.artWalkContainerView.bounds.height)
//        artWalkContainerView.addSubview(artWalkNavigationController.view)
//
//       // artWalkContainerView.sizeToFit()
      
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
                    )
                    self.direction = directions
                    self.instructions = self.direction.instructions.map { instruction in
                        return instruction.instruction ?? "Unknown"
                    }
                    self.directionsData.reloadData()
                    self.ontrack = true
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
            startScanning()

            
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
        let nearestNode = blueDot.nearestNode
       // self.mapMpiView.createMarker(node: nearestNode, contentHtml: markerString ?? "")


    }

    func onDataLoaded(data: MPIData) {
        // Called when the mapView has finished loading both the view and venue data
        self.didFinishLoadingMap?()
        if let gallery = self.artWalkContainerView.viewContainingController() as? UINavigationController {
          //  gallery?.allLocations = self.allLocations//
           // print
        }
        
    }

    func onFirstMapLoaded() {
        // Called when the first map is fully loaded
        self.allLocations = mapMpiView.venueData?.locations ?? []
        
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
            let coordinates = MPICoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, accuracy: 0.8, floorLevel: location.floor?.level)
            self.mapMpiView.blueDotManager.updatePosition(position: MPIPosition(timestamp: dateTime.timeIntervalSince1970, coords: coordinates, type: "", annotation: ""))
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorized {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("⚠️ \(beacons)")
        for beacon in beacons {
            let foundedBeacon = getBeaconByMayorAndMinor(mayor: beacon.major.intValue, minor: beacon.minor.intValue)
            foundedBeacon.proximity = 0
            foundedBeacon.rrsi = beacon.rssi
            foundedBeacon.timeStamp = beacon.timestamp
            let beacon = "\(beacon)"
            let splitInQoutes = beacon.split(separator: ",")[3]
            let splitInTwoPoints = splitInQoutes.split(separator: ":")[1]
            let distance = splitInTwoPoints.split(separator: " ")[2]
            let rawDistance = distance.replacingOccurrences(of: "m", with: "")
            let proximity = Double(String(rawDistance)) ?? 0
            foundedBeacon.proximity = proximity
        }
        
        NotificationCenter.default.post(name: Notification.Name("didRangeBeacons"), object: nil)

        
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
