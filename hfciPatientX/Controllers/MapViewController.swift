//
//  MapViewController.swift
//  hfciPatientX
//
//  Created by developer on 15/09/21.
//

import UIKit
import Mappedin


class MapViewController: UIViewController {

    var mapView: MPIMapView!
    lazy var venueDataString = getFileContentFromBundle(forResource: "mappedin-demo-mall", ofType: "json")
    lazy var connectionTemplateString = getFileContentFromBundle(forResource: "connectionTemplate", ofType: "html")
    lazy var markerString = getFileContentFromBundle(forResource: "marker", ofType: "html")
    @IBOutlet weak var mapListView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let screenRect = UIScreen.main.bounds
           let screenWidth = screenRect.size.width
           let screenHeight = screenRect.size.height

           // Set up MPIMapView and add to view
           mapView = MPIMapView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        view.addSubview(mapView)
        if let mapView = mapView {
              self.view.insertSubview(mapView, belowSubview: mapListView)
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
        return self.mapView?.venueData?.maps.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mapView?.venueData?.maps[row].name ?? ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let selectedMap = mapView?.venueData?.maps[row] {
            mapView?.setMap(map: selectedMap)
        }
    }

}
