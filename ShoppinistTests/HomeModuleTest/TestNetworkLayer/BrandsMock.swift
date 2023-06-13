//
//  BrandsMock.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 13/06/2023.
//

import Foundation
@testable import Shoppinist


final class BrandsMock{
    static let brandsData = "{\"smart_collections\":[{\"id\":447912444196,\"handle\":\"adidas\",\"title\":\"ADIDAS\",\"updated_at\":\"2023-06-01T06:58:17-04:00\",\"body_html\":\"Adidascollection\",\"published_at\":\"2023-05-31T05:39:37-04:00\",\"sort_order\":\"best-selling\",\"template_suffix\":null,\"disjunctive\":false,\"rules\":[{\"column\":\"title\",\"relation\":\"contains\",\"condition\":\"ADIDAS\"}],\"published_scope\":\"web\",\"admin_graphql_api_id\":\"gid://shopify/Collection/447912444196\",\"image\":{\"created_at\":\"2023-05-31T05:39:37-04:00\",\"alt\":null,\"width\":1000,\"height\":676,\"src\":\"https://cdn.shopify.com/s/files/1/0767/8184/6820/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1685525977\"}},{\"id\":447912542500,\"handle\":\"asics-tiger\",\"title\":\"ASICSTIGER\",\"updated_at\":\"2023-06-01T06:58:17-04:00\",\"body_html\":\"AsicsTigercollection\",\"published_at\":\"2023-05-31T05:39:40-04:00\",\"sort_order\":\"best-selling\",\"template_suffix\":null,\"disjunctive\":false,\"rules\":[{\"column\":\"title\",\"relation\":\"contains\",\"condition\":\"ASICSTIGER\"}],\"published_scope\":\"web\",\"admin_graphql_api_id\":\"gid://shopify/Collection/447912542500\",\"image\":{\"created_at\":\"2023-05-31T05:39:40-04:00\",\"alt\":null,\"width\":425,\"height\":220,\"src\":\"https://cdn.shopify.com/s/files/1/0767/8184/6820/collections/b351cead33b2b72e7177e70512530f09.jpg?v=1685525980\"}}]}"
}
extension BrandsMock : HomeRemoteDataSourceProtocol{
    func fetchBrands(compilitionHandler: @escaping (Shoppinist.BrandModel?) -> Void) {
        let data = Data (BrandsMock.brandsData.utf8)
        do{
            let result = try JSONDecoder().decode(BrandModel.self, from: data)
            compilitionHandler(result)
        }catch let error{
            print(error.localizedDescription)
            compilitionHandler(nil)
        }
    }
}
