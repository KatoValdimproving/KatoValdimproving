//
//  GroupViewController.swift
//  hfciPatientX
//
//  Created by developer on 15/10/21.
//

import UIKit

class GroupViewController: UIViewController {
    
    @IBOutlet weak var navigateButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigateButton.layer.cornerRadius = 10

        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        
        
       // collectionView.collectionViewLayout = self
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "ItemGroupCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ItemGroupCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self

        self.collectionView.contentInsetAdjustmentBehavior = .automatic

    }
    
    override func viewDidLayoutSubviews() {
        flowLayout.itemSize = CGSize(width: (self.view.frame.width/1) - 2, height: 100)
        collectionView.collectionViewLayout = flowLayout
//        guidedTourButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
//        guidedTourButton.setTitle("Guided Art Walk", for: .normal)
        
        self.titleLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Simbiosis", sizeTop: 27, secondLine: "Hanna Frost", sizeBottom: 17, color: .black)
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.flowLayout.invalidateLayout()
        navigateButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
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

extension GroupViewController: UICollectionViewDelegate {
    
   
    
}

extension GroupViewController: UICollectionViewDataSource {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemGroupCollectionViewCell", for: indexPath) as? ItemGroupCollectionViewCell
        return cell!
    }
}
