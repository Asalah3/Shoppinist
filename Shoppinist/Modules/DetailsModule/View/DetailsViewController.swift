//
//  DetailsViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import UIKit

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var detailsSlider: UIPageControl!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    @IBOutlet weak var detailsName: UILabel!
    @IBOutlet weak var detailsPrice: UILabel!
    @IBOutlet weak var detailsRate: UIView!
    @IBOutlet weak var detailsDescription: UITextView!
    @IBOutlet weak var detailsFavButton: UIButton!
    
    var product : Product?
    var currency : String = "EGP"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsName.text = "\(String(describing: product?.vendor))|\(String(describing: product?.productType))"
        detailsPrice.text = "\(String(describing: product?.variants[0].price)) \(currency)"
        detailsDescription.text = product?.publishedScope
        detailsSlider.currentPage = 0
        detailsSlider.numberOfPages = product?.images?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as? DetailsCollectionViewCell
        cell?.detailsImage.sd_setImage(with: URL(string:product?.images?[indexPath.row].src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
        
        
        return cell ?? DetailsCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        detailsSlider.currentPage = indexPath.row
    }
    

    @IBAction func addToFav(_ sender: Any) {
    }
    
    @IBAction func addToBag(_ sender: Any) {
    }
    
}
