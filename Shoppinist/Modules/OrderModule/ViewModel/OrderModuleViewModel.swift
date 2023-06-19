//
//  OrderModuleViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 05/06/2023.
//

import Foundation
protocol OrderModuleViewModelProtocol{
    func createOrder(order: PostOrdersModel)
    var observableCreateOrder:Int!{get set}
    var bindingOrderCreated:(()->()) {get set}
    func deleteShoppingCart(completion: @escaping (Error?) -> ())
}
class OrderModuleViewModel: OrderModuleViewModelProtocol{
    var remote : OrderRemoteDataSourceProtocol?
    init(remote: OrderRemoteDataSourceProtocol) {
        self.remote = remote
    }
    var bindingOrderCreated: (() -> ()) = {}
    var observableCreateOrder: Int!{
        didSet{
            bindingOrderCreated()
        }
    }
    
    func createOrder(order: PostOrdersModel) {
        remote?.createOrder(order: order){ [weak self] order in
            self?.observableCreateOrder = order
        }
    }
    
    func deleteShoppingCart(completion: @escaping (Error?) -> ()) {
//        CartNetwork.deleteCart { error in
//            guard error == nil else {
//                print("draft order deleting error")
//                completion(error)
//                return
//            }
//            print("draft order deleted")
//            completion(nil)
//        }
    }
}
