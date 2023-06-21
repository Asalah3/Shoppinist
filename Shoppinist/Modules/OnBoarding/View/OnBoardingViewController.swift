//
//  OnBoardingViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 07/06/2023.
//

import UIKit

class OnBoardingViewController: UIViewController {
    let appDelegate = UIApplication.shared.windows.first
    var slides : [OnBoardingSlide] = [
        OnBoardingSlide(title: "Order for Items", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", image: UIImage(named: "1")!),
        OnBoardingSlide(title: "Payment Process", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", image: UIImage(named: "2")!),
        OnBoardingSlide(title: "Items Delivery", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", image: UIImage(named: "3")!)]
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1{
                skipButton.setTitle("Get Started", for: .normal)
            }else{
                skipButton.setTitle("Next", for: .normal)
            }
        }
    }
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewWillAppear(_ animated: Bool) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        pageControl.numberOfPages = slides.count
        self.collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "Dark"){
            
            appDelegate?.overrideUserInterfaceStyle = .dark

        }
        else{
           
            appDelegate?.overrideUserInterfaceStyle = .light

        }
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func skipButton(_ sender: Any) {
        
        if currentPage == slides.count - 1 {
            let choosingAuthWayViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChoosingAuthWayViewController") as? ChoosingAuthWayViewController
            choosingAuthWayViewController?.modalTransitionStyle = .crossDissolve
            choosingAuthWayViewController?.modalPresentationStyle = .fullScreen
            UserDefaults.standard.hasOnboarded = true
            self.navigationController?.pushViewController(choosingAuthWayViewController!, animated: true)
        }else{
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
extension OnBoardingViewController: UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.identifier, for: indexPath) as! OnBoardingCollectionViewCell
        cell.setUp(slides[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
