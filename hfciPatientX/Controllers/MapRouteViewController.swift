//
//  MapRouteViewController.swift
//  hfciPatientX
//
//  Created by user on 30/09/21.
//

import UIKit
import Mappedin
import DropDown

class MapRouteViewController: UIViewController {
    
    var location : [MPILocation] = []
    
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var fromSelect: UIView!
    @IBOutlet weak var toSelect: UIView!
    
    var mapMpiView: MPIMapView!
    
    @IBOutlet weak var mapListView: UITextField!
    
    @IBOutlet weak var fromPlace: UILabel!
    @IBOutlet weak var toPlace: UILabel!
    
    var fromMenu : DropDown = {
        let menu = DropDown()
        return menu
    }()
    
    var toMenu : DropDown = {
        let menu = DropDown()
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapMpiView = MPIMapView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: mapView.frame.size))

        self.mapView.addSubview(mapMpiView)
        if let mapView = mapMpiView {
              self.mapView.insertSubview(mapView, belowSubview: mapListView)
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
                showVenueOptions: MPIOptions.ShowVenue(labelAllLocationsOnInit: true, backgroundColor: "#222222")
              )
            mapView.backgroundColor = .white
            }
        
        createPickerView()
        dismissPickerView()
                
        self.mapMpiView.delegate = self
        
        fromMenu.anchorView = fromSelect
        fromMenu.selectionAction = { index, title in
            self.fromPlace.text = title
        }
        
        toMenu.anchorView = toSelect
        toMenu.selectionAction = { index, title in
            self.toPlace.text = title
            self.getDirection()
        }

        let gestureFrom = UITapGestureRecognizer(target: self, action: #selector(didTapFrom))
        gestureFrom.numberOfTapsRequired = 1
        gestureFrom.numberOfTouchesRequired = 1
        fromSelect.addGestureRecognizer(gestureFrom)
        
        let gestureTo = UITapGestureRecognizer(target: self, action: #selector(didTapTo))
        gestureTo.numberOfTapsRequired = 1
        gestureTo.numberOfTouchesRequired = 1
        toSelect.addGestureRecognizer(gestureTo)
        // Do any additional setup after loading the view.
    }
    
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        mapListView.inputView = pickerView
        mapListView.tintColor = UIColor.clear
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        mapListView.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
    
    @objc func didTapFrom() {
        fromMenu.show()
    }
    
    @objc func didTapTo() {
        toMenu.show()
    }

    func getDirection() {
        let from : MPILocation = location[fromMenu.indexForSelectedRow ?? 0]
        let to : MPILocation = location[toMenu.indexForSelectedRow ?? 0]
        
        self.mapMpiView?.getDirections(to: to.polygons?.first as! MPINavigatable, from: from.nodes?.first as! MPINavigatable, accessible: true) { directions in
            if let directions = directions {
                self.mapMpiView?.drawJourney(
                    directions: directions,
                    options: MPIOptions.Journey(
                        pathOptions: MPIOptions.Path(color: "#cdcdcd", pulseColor: "#000000", displayArrowsOnPath: true)
                    )
                )
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapRouteViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }

}

extension MapRouteViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.mapMpiView?.venueData?.maps.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mapMpiView?.venueData?.maps[row].name ?? ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let selectedMap = mapMpiView?.venueData?.maps[row] {
            mapMpiView?.setMap(map: selectedMap)
        }
    }

}

extension MapRouteViewController: MPIMapViewDelegate {
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
        self.location = mapMpiView.venueData?.locations ?? []
        
        self.location = self.location.filter { location in
            location.polygons!.count > 0 && location.nodes!.count > 0
        }
                
        self.fromMenu.dataSource = mapMpiView.venueData?.locations.map({ (element: MPILocation) -> String in
            element.name
        }) ?? []
        
        self.toMenu.dataSource = mapMpiView.venueData?.locations.map({ (element: MPILocation) -> String in
            element.name
        }) ?? []
    }

    func onStateChanged (state: MPIState) {
        // Called when the state of the map has changed
    }
}
