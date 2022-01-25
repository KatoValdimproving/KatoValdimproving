//
//  GalleryViewController.swift
//  hfciPatientX
//
//  Created by developer on 12/10/21.
//

import UIKit
import Mappedin




class GalleryViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()
    var selectedPainting: Painting?
    var allLocations : [MPILocation] = []
    var selectedLocation: MPILocation?
    var mapViewController: MapViewController?
    var isFiltering = false
    var filteredPaintings: [Painting] = []
    var paintingList : [Painting] = []
    var paintingTour : [Painting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        print("width vvv \(self.view.frame.width)")
        
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification), name: Notification.Name("didRangeBeacons"), object: nil)
        
        
       // collectionView.collectionViewLayout = self
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self

        self.collectionView.contentInsetAdjustmentBehavior = .automatic
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        paintingList = paintings

    }
    
    @objc func methodOfReceivedNotification() {
        
        paintingList.sort {
            ($0.beacon?.proximity ?? 100) > ($1.beacon?.proximity ?? 100)
        }
        
        collectionView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        flowLayout.itemSize = CGSize(width: (self.view.frame.width/1) - 2, height: (self.view.frame.width  / 1) - 2)
        collectionView.collectionViewLayout = flowLayout
         self.mapViewController?.showGoToArtwalkButton(isHidden: true)
    }
    
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews() 
//        self.flowLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  guidedTourButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .bold)
      //  self.mapViewController?.showGoToArtwalkButton(isHidden: true)

    }
    @IBAction func guidedArtWalkAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Select a nearby piece of art from the menu to start your tour.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Start", style: .default) {
            UIAlertAction in
            self.mapViewController?.startScanningPainting(painting: nil)
            self.mapViewController?.guidedArtWalk()
            self.paintingList.removeAll { element in
                return element.title == "Rust and Roses"
            }
            self.paintingTour = self.paintingList
            self.collectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            
        }

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
        
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
    
    func nextPainting(){
        if(self.mapViewController?.visitedPaints.count == paintingTour.count){
            self.mapViewController?.endTour(self)
        }else{
            let index = paintingTour.firstIndex { element in
                self.mapViewController?.visitedPaints.last == element.title
            }
            if (index != nil && (index! + 1) < paintingTour.count){
                self.selectedPaint(index: index! + 1)
            } else{
                self.selectedPaint(index: 0)
            }
        }
    }
    
    func presentPaintingInfo(title: String){
        let index = paintingList.firstIndex { element in
            title == element.title
        }
        self.selectedPainting = paintingList[index!]
        self.performSegue(withIdentifier: "pictureDetail", sender: self)
    }
    
    func selectedPaint(index: Int){
        if(mapViewController?.gidedArtTour != nil && mapViewController!.gidedArtTour){
            self.selectedPainting = isFiltering ? filteredPaintings[index] :  paintingTour[index]
            self.mapViewController?.visitedPaints.append(self.selectedPainting!.title)
            self.performSegue(withIdentifier: "pictureDetail", sender: self)
        }else{
            self.selectedPainting = isFiltering ? filteredPaintings[index] :  paintingList[index]
            self.performSegue(withIdentifier: "pictureDetail", sender: self)
        }
    }

}

extension GalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPaint(index: indexPath.row)
    }
    
}

extension GalleryViewController: UICollectionViewDataSource {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? filteredPaintings.count :  paintingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as? GalleryCollectionViewCell
        let painting = isFiltering ? filteredPaintings[indexPath.row] :  paintingList[indexPath.row]
        cell?.setInfo(painting: painting)
        return cell!
    }
    
    
}

extension GalleryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        filteredPaintings = []

        if searchText == "" {
            self.isFiltering = false
            self.collectionView.reloadData()
            return
        }
            
        for painting in paintingList {
            if painting.title.lowercased().contains(searchText.lowercased()) {
                filteredPaintings.append(painting)
            }
                
        }
        
        self.isFiltering = true

        self.collectionView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       // self.isFiltering = true
     //   self.collectionView.reloadData()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.isFiltering = false
//        self.collectionView.reloadData()

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
 //       self.isFiltering = false
//        self.collectionView.reloadData()

    }
    
    func orderPaints(){
        
    }
    
    func endTour() {
        paintingList = paintings
        collectionView.reloadData()
    }
    
}

