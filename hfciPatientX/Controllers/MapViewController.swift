//
//  MapViewController.swift
//  hfciPatientX
//
//  Created by developer on 15/09/21.
//

import UIKit
import DropDown
import Mappedin

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var exitImg: UIImageView!
        
    @IBOutlet weak var barview: UIView!
    @IBOutlet weak var locationData: UITableView!
    
    @IBOutlet weak var exploreView: RoundedButtonView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var directionsView: RoundedView!
    
    var mapMpiView: MPIMapView!
    var allLocations : [MPILocation] = []
    var polygonLocations : [MPILocation] = []
    var nodeLocations : [MPILocation] = []
    var point1 : MPILocation!
    var point2 : MPILocation!
        
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
    
    @IBAction func goBack(_ sender: Any) {
        directionsView.isHidden = true
        controlls.isHidden = false
        fromWhereView.isHidden = true
        titleLbl.text = "Points of Interest"
        self.polygonLocations = self.allLocations.filter { location in
            location.polygons!.count > 0
        }
        self.locationData.reloadData()
        mapMpiView.reload()
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.directionsView.isHidden = true
        self.fromWhereView.isHidden = true
           // Set up MPIMapView and add to view
        mapMpiView = MPIMapView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: mapView.frame.size))
        
        self.mapView.addSubview(mapMpiView)
        if let mapView = mapMpiView {
              // Provide credentials, if using proxy use MPIOptions.Init(venue: "venue_slug", baseUrl: "proxy_url", noAuth: true)
            mapView.loadVenue(
                options: MPIOptions.Init(
                  clientId: "601c2371fac662001be42493",
                  clientSecret: "raW1AeQ5WikKMflCbX5GAozTA0kcGsgl99HUIJHr1B6wwgoG",
                  venue: "henry-ford-cancer-center"
                )
              )
            mapView.loadVenue(
                options: MPIOptions.Init(
                  clientId: "601c2371fac662001be42493",
                  clientSecret: "raW1AeQ5WikKMflCbX5GAozTA0kcGsgl99HUIJHr1B6wwgoG",
                  venue: "henry-ford-cancer-center",
                  headers: [MPIHeader(name: "customheader", value: "HappyTest")]
                ),
                showVenueOptions: MPIOptions.ShowVenue(labelAllLocationsOnInit: true, backgroundColor: "#ffffff")
              )
            }
                
        self.mapMpiView.delegate = self
        self.locationData.delegate = self
        self.locationData.dataSource = self
        self.locationData.rowHeight = 80.0
        registerTableViewCells()
        
        let exitGesture = UITapGestureRecognizer(target: self, action: #selector(didExit))
        exitGesture.numberOfTapsRequired = 1
        exitGesture.numberOfTouchesRequired = 1
        exitImg.isUserInteractionEnabled = true
        exitImg.addGestureRecognizer(exitGesture)
        
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
        }
        
        toSelect.anchorView = toViewSelect
        toSelect.selectionAction = { index, title in
            self.tolbl.text = title
            self.point2 = self.polygonLocations[index]
            self.getDirection()
        }
        
        floorSelect.anchorView = floorSelector
        floorSelect.selectionAction = { index, title in
            self.floorLBL.text = title
            if let selectedMap = self.mapMpiView?.venueData?.maps[index] {
                self.mapMpiView?.setMap(map: selectedMap)
            }
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
    
    private func registerTableViewCells() {
        let cell = UINib(nibName: "PointCellTableViewCell", bundle: nil)
        self.locationData.register(cell, forCellReuseIdentifier: "PointCellTableViewCell")
    }
    
    private func getFileContentFromBundle(forResource: String, ofType: String) -> String? {
        guard let path = Bundle.main.path(forResource: forResource, ofType: ofType) else { return nil }
        return try? String(contentsOfFile: path)
    }
    
    @objc func action() {
        view.endEditing(true)
    }
    
    @objc func didExit() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func explore() {
        self.polygonLocations = self.allLocations.filter { location in
            location.type == "amenities" && location.polygons!.count > 0
        }
        
        self.locationData.reloadData()
        
        titleLbl.text = "Amenities"
    }
    
    func filterLocations() {
        self.nodeLocations = self.allLocations.filter { location in
            location.nodes!.count > 0
        }
        
        self.polygonLocations = self.allLocations.filter { location in
            location.polygons!.count > 0
        }
        
        selectMenu.dataSource = self.nodeLocations.map({ location in
            location.name
        })
        
        fromSelect.dataSource = self.nodeLocations.map({ location in
            location.name
        })
        
        toSelect.dataSource = self.polygonLocations.map({ location in
            location.name
        })
    }
    
    func getDirection() {
        
        self.mapMpiView.focusOn(focusOptions: MPIOptions.Focus(nodes: point2.nodes, polygons: point2.polygons, duration: 0.2, changeZoom: true, minZoom: 0.1, tilt: 0.2, padding: .none , focusZoomFactor: 0.4))
        
        self.mapMpiView?.getDirections(to: point2.polygons?.first as! MPINavigatable, from: point1.nodes?.first as! MPINavigatable, accessible: true) { directions in
            if let directions = directions {
                self.mapMpiView?.drawJourney(
                    directions: directions,
                    options: MPIOptions.Journey(
                        pathOptions: MPIOptions.Path(color: "#F44F36", pulseColor: "#000000", displayArrowsOnPath: true)
                    )
                )
            }
        }
    }
}

extension MapViewController: MPIMapViewDelegate {
    func onBlueDotPositionUpdate(update: MPIBlueDotPositionUpdate) {
        // Called when the blueDot that tracks the user position is updated
    }

    func onBlueDotStateChange(stateChange: MPIBlueDotStateChange) {
        // Called when the state of blueDot is changed
    }

    func onMapChanged(map: MPIMap) {
        
    }

    func onPolygonClicked(polygon: MPIPolygon) {
        // Called when the polygon is clicked
    }

    func onNothingClicked() {
        // Called when a tap doesn't hit any spaces
    }

    @available(*, deprecated, message: "use onBlueDotPositionUpdate and onBlueDotStateChange")
    func onBlueDotUpdated(blueDot: MPIBlueDot) {
    }

    func onDataLoaded(data: MPIData) {
        // Called when the mapView has finished loading both the view and venue data
    }

    func onFirstMapLoaded() {
        // Called when the first map is fully loaded
        self.allLocations = mapMpiView.venueData?.locations ?? []
        
        self.filterLocations()
        
        floorSelect.dataSource = mapMpiView?.venueData?.maps.map({ mapElement in
            mapElement.name
        }) ?? []
        floorLBL.text = mapMpiView?.venueData?.maps.first?.name
        
        self.locationData.reloadData()
    }

    func onStateChanged (state: MPIState) {
        // Called when the state of the map has changed
    }
}

extension MapViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.polygonLocations[indexPath.row]
        if ((data.polygons?.count) != nil) {
            point2 =  self.polygonLocations[indexPath.row]
            self.fromWhereView.isHidden = false
        }
        
        if data.nodes!.count > 0 {
            self.mapMpiView.focusOn(focusOptions: MPIOptions.Focus(nodes: data.nodes, polygons: data.polygons, duration: 0.2, changeZoom: true, minZoom: 0.4, tilt: 0.2, padding: .none , focusZoomFactor: 0.2))
        }
    }
}

extension MapViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.polygonLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PointCellTableViewCell") as? PointCellTableViewCell {
            let data = self.polygonLocations[indexPath.row]
            cell.locationDesc.text = data.name
            cell.floor.text = "Floor"
            return cell
        }
            
        return UITableViewCell()
    }
}
