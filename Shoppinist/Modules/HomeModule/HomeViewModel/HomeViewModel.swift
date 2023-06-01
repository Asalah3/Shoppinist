//
//  HomeViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import Foundation
protocol HomeViewModelProtocol{
    func fetchHomeData(resourse :String)
}
class HomeViewModel :HomeViewModelProtocol {
    var remote :RemoteDataSourceProtocol?
    init( remoteDataSource: RemoteDataSourceProtocol) {
        self.remote = remoteDataSource
    }
    var fetchBrandsToHomeViewController : (()->())={}
    var fetchHomeData:BrandModel!{
        didSet{
            fetchBrandsToHomeViewController()
        }
    }
    func fetchHomeData(resourse: String) {
        remote?.fetchBrands{ result in
            guard let result = result else {return}
            self.fetchHomeData = result
        }
    }
}
