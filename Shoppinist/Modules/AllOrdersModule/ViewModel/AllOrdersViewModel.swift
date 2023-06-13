//
//  AllOrdersViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 13/06/2023.
//

import Foundation
protocol AllOrdersViewModelProtocol{
    func fetchOrdersData(customerId: Int)
    var fetchAllOrdersData:[Order]!{get set}
    var fetchOrdersToAllOrdersViewController : (()->()) { get set }
    func deleteOrder(orderId: Int)
    var observableDeleteOrder:Int!{get set}
    var bindingOrderDelete:(()->()) {get set}
}
class AllOrdersViewModel: AllOrdersViewModelProtocol{
    var remote : AllOrderRemoteDataSourceProtocol?
    init(remote: AllOrderRemoteDataSourceProtocol) {
        self.remote = remote
    }
    
//    ------------ DeleteOrder ------------
    var bindingOrderDelete: (() -> ()) = {}
    var observableDeleteOrder: Int!{
        didSet{
            bindingOrderDelete()
        }
    }
    func deleteOrder(orderId: Int) {
        remote?.deleteOrder(orderID: orderId){ order in
            self.observableDeleteOrder = order
            
        }
    }
    
//    ------------ AllOrders ------------
    var fetchOrdersToAllOrdersViewController: (() -> ()) = {}
    var fetchAllOrdersData: [Order]!{
        didSet{
            fetchOrdersToAllOrdersViewController()
        }
    }
    
    func fetchOrdersData(customerId: Int) {
        remote?.getAllOrders{[weak self] (result) in
            guard let result = result else {return}
            let customerOrders = result.orders?.filter({$0.customer?.id == customerId})
            self?.fetchAllOrdersData = customerOrders
        }
    }
    
}
