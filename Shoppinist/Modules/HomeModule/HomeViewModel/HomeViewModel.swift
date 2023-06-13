//
//  HomeViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import Foundation
protocol HomeViewModelProtocol{
    func fetchHomeData(resourse :String)
    var fetchHomeData:BrandModel!{get set}
    var fetchBrandsToHomeViewController : (()->()) { get set }
}
class HomeViewModel :HomeViewModelProtocol {
    var fetchHomeData: BrandModel!{
        didSet{
            fetchBrandsToHomeViewController()
        }
    }
    var remote : HomeRemoteDataSourceProtocol?
    init(remote: HomeRemoteDataSourceProtocol) {
        self.remote = remote
    }
    var fetchBrandsToHomeViewController : (()->())={}
    func fetchHomeData(resourse: String) {
        remote?.fetchBrands{ result in
            guard let result = result else {return}
            self.fetchHomeData = result
        }
    }
}
