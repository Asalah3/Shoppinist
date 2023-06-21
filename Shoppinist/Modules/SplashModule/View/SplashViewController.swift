//
//  SplashViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 17/06/2023.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    var ViewModel: SplashViewModel!
    let appDelegate = UIApplication.shared.windows.first
    @IBOutlet weak var splashView: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
   
        ViewModel = SplashViewModel()
        ViewModel.changeCurrency()
        self.ViewModel?.fetchCurrencyToCell = { [weak self] in
            DispatchQueue.main.async {
                let currency = Double(self?.ViewModel?.fetchCurrencyData?.rates.egp ?? "0") ?? 0.0
                UserDefaults.standard.set(currency, forKey: "EGP")
                print("EPG = \(UserDefaults.standard.double(forKey: "EGP"))")
            }
        }
        splashView.contentMode = .scaleAspectFit
        splashView.loopMode = .loop
        splashView.play()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(navigate), userInfo: nil, repeats: false)
    }
    override func viewWillAppear( _ animated: Bool){
        if UserDefaults.standard.bool(forKey: "Dark"){
            
            appDelegate?.overrideUserInterfaceStyle = .dark
            
        }
        else{
            
            appDelegate?.overrideUserInterfaceStyle = .light
            
        }
    }

    @objc func navigate(){
        if UserDefaults.standard.hasOnboarded {
            if UserDefaults.standard.integer(forKey:"customerID") == 0{
                let choosingAuthWayViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChoosingAuthWayViewController") as? ChoosingAuthWayViewController
                choosingAuthWayViewController?.modalTransitionStyle = .crossDissolve
                choosingAuthWayViewController?.modalPresentationStyle = .fullScreen
                UserDefaults.standard.hasOnboarded = true
                self.navigationController?.pushViewController(choosingAuthWayViewController!, animated: true)
            }else if UserDefaults.standard.integer(forKey:"customerID") != 0{
                let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
                tabBarController?.modalTransitionStyle = .crossDissolve
                tabBarController?.modalPresentationStyle = .fullScreen
                UserDefaults.standard.hasOnboarded = true
                self.present(tabBarController!, animated: true)
            }
            
        }else{
            let onBoardingViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnBoardingViewController") as? OnBoardingViewController
            onBoardingViewController?.modalTransitionStyle = .crossDissolve
            onBoardingViewController?.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(onBoardingViewController!, animated: true)
        }
        
    }

}
