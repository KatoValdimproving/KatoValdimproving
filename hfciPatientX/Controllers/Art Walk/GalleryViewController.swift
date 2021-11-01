//
//  GalleryViewController.swift
//  hfciPatientX
//
//  Created by developer on 12/10/21.
//

import UIKit
import Mappedin




class GalleryViewController: UIViewController {

    @IBOutlet weak var guidedTourButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()
    var selectedPainting: Painting?
    var allLocations : [MPILocation] = []
    var selectedLocation: MPILocation?
    var mapViewController: MapViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guidedTourButton.layer.cornerRadius = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        print("width vvv \(self.view.frame.width)")
        
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        
        
       // collectionView.collectionViewLayout = self
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self

        self.collectionView.contentInsetAdjustmentBehavior = .automatic
        

    }
    
    override func viewDidLayoutSubviews() {
        flowLayout.itemSize = CGSize(width: (self.view.frame.width/1) - 2, height: (self.view.frame.width  / 1) - 2)
        collectionView.collectionViewLayout = flowLayout
       guidedTourButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
//        guidedTourButton.setTitle("Guided Art Walk", for: .normal)
         self.mapViewController?.showGoToArtwalkButton(isHidden: true)

       
       
    }
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.flowLayout.invalidateLayout()
        guidedTourButton.setTitle("Guided Art Walk", for: .normal)
     //   guidedTourButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)

    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  guidedTourButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .bold)
      //  self.mapViewController?.showGoToArtwalkButton(isHidden: true)

    }
    @IBAction func guidedArtWalkAction(_ sender: Any) {
        self.mapViewController?.guidedArtWalkFromCurrentLocation()
    }
    
    func setAllLocations() {
        print(self.allLocations)
        print(" //////  locations names and id /////////////")
        for location in self.allLocations {
            
            print(location.id)
            print(location.name)

        }
        print(" ///////////////////")

    }

    // MARK: - Navigation

   //  In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let paintingDetailViewController = segue.destination as? PaintingDetailViewController
        paintingDetailViewController?.mapViewController = self.mapViewController
        paintingDetailViewController?.painting = self.selectedPainting
    }
    
//    func getLocation(name: String) -> MPILocation {
//        let location = self.allLocations.filter { location in
//            return location.name == name
//        }
//        
//        return location.first!
//    }
    
     
    

}

extension GalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPainting = paintings[indexPath.row]
        
//        self.selectedLocation = getLocation(name: getBeaconByPaintiingTitle(title: self.selectedPainting!.title)!.location)
        self.performSegue(withIdentifier: "pictureDetail", sender: self)
    }
    
}

extension GalleryViewController: UICollectionViewDataSource {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paintings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as? GalleryCollectionViewCell
        let painting = paintings[indexPath.row]
        cell?.setInfo(painting: painting)
        return cell!
    }
    
    
}


