//
//  MapViewController.swift
//  hfciPatientX
//
//  Created by developer on 15/09/21.
//

import UIKit
import Mappedin


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var exitImg: UIImageView!
    @IBOutlet weak var selctor: UITextField!
    
    @IBOutlet weak var exploreView: RoundedView!
    
    @IBOutlet weak var locationData: UITableView!
    
    var mapMpiView: MPIMapView!
    var location : [MPILocation] = []
    
    @IBOutlet weak var mapListView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

           // Set up MPIMapView and add to view
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
            }
        
        createPickerView()
        dismissPickerView()
                
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
    }
    
    private func registerTableViewCells() {
        let cell = UINib(nibName: "PointCellTableViewCell", bundle: nil)
        self.locationData.register(cell, forCellReuseIdentifier: "PointCellTableViewCell")
    }
    
    private func getFileContentFromBundle(forResource: String, ofType: String) -> String? {
        guard let path = Bundle.main.path(forResource: forResource, ofType: ofType) else { return nil }
        return try? String(contentsOfFile: path)
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
    
    @objc func didExit() {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
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

extension MapViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }

}

extension MapViewController: UIPickerViewDelegate {

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
        self.location = mapMpiView.venueData?.locations ?? []
        
        self.location = self.location.filter { location in
            location.type == "amenities" && location.nodes?.count > 0
        }
        
        self.locationData.reloadData()
    }

    func onStateChanged (state: MPIState) {
        // Called when the state of the map has changed
    }
}

extension MapViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.location[indexPath.row].polygons as Any)
        print(self.location[indexPath.row].nodes as Any)
        
        let data = self.location[indexPath.row]
        if data.nodes!.count > 0 {
            self.mapMpiView.focusOn(focusOptions: MPIOptions.Focus(nodes: data.nodes, polygons: data.polygons, duration: 0.2, changeZoom: true, minZoom: 0.4, tilt: 0.2, padding: .none , focusZoomFactor: 0.2))
        }
    }
}

extension MapViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.location.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PointCellTableViewCell") as? PointCellTableViewCell {
            let data = self.location[indexPath.row]
            cell.locationDesc.text = data.name
            cell.floor.text = self.mapListView.text
                return cell
            }
            
        return UITableViewCell()
    }
}
