//
//  OrderModuleViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 05/06/2023.
//

import Foundation
protocol OrderModuleViewModelProtocol{
    func createOrder(order: OrdersModel)
    var observableCreateOrder:Int!{get set}
    var bindingOrderCreated:(()->()) {get set}
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
    
    func createOrder(order: OrdersModel) {
        remote?.createOrder(order: order){ [weak self] order in
            self?.observableCreateOrder = order
        }
    }
}
