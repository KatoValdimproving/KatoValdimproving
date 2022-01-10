//
//  MapVMViewController.swift
//  hfciPatientX
//
//  Created by user on 21/12/21.
//

import UIKit
import Mappedin

class MapVMViewController: UIViewController, MPIMapViewDelegate {
    
    func onDataLoaded(data: MPIData) {
        
    }
    
    func onFirstMapLoaded() {
        
    }
    
    func onMapChanged(map: MPIMap) {
        
    }
    
    func onPolygonClicked(polygon: MPIPolygon) {
        
    }
    
    func onNothingClicked() {
        
    }
    
    func onBlueDotPositionUpdate(update: MPIBlueDotPositionUpdate) {
        
    }
    
    func onBlueDotStateChange(stateChange: MPIBlueDotStateChange) {
        
    }
    
    func onStateChanged(state: MPIState) {
        
    }
    
    
    var mapLocations : [MPILocation] = []            
    var mapView : MPIMapView!

    let centerButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMap()
        // Do any additional setup after loading the view.
    }

    func getAmenities() -> [MPILocation] {
        return []
    }
    
    func getPaintings() -> [MPILocation] {
        return []
    }
    
    func loadMap() {
        mapView = MPIMapView(frame: CGRect(x: 0, y: 0, width: 750, height: 800))
        if let map = mapView {
            map.loadVenue(
                options: MPIOptions.Init(
                  clientId: "601c2371fac662001be42493",
                  clientSecret: "raW1AeQ5WikKMflCbX5GAozTA0kcGsgl99HUIJHr1B6wwgoG",
                  venue: "henry-ford-cancer-center"
                ),
                showVenueOptions: MPIOptions.ShowVenue(labelAllLocationsOnInit: true, backgroundColor: "#ffffff")
              )
        } else {
            return
        }
        
        mapView.delegate = self
        
        centerButton.frame = CGRect(x: self.mapView.frame.width - 80, y: self.mapView.frame.height - 150, width: self.mapView.frame.width/12, height: self.mapView.frame.width/12)
        centerButton.layer.cornerRadius = 0.5 * centerButton.bounds.size.width
        centerButton.clipsToBounds = true
        centerButton.setImage(UIImage(named:"myLocation"), for: .normal)
        centerButton.addTarget(self, action: #selector(setStateToFollow), for: .touchUpInside)
        mapView.addSubview(centerButton)
        
        
        self.view.addSubview(mapView)
    }
    
    @IBAction func setStateToFollow(){
        self.mapView.blueDotManager.setState(state: .FOLLOW)
    }

}
