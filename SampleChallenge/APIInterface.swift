//
//  APIInterface.swift
//  SampleChallenge
//
//  Created by ashif khan on 18/09/18.
//  Copyright © 2018 ashif khan. All rights reserved.
//

import UIKit
typealias APIInterfaceResponseBlock = (_ data:Data?, _ error:Error?) -> Void
class APIInterface: NSObject {
    fileprivate let baseURLPath:String = "https://mock-api-mobile.dev.lalamove.com"
    fileprivate let endPointDeliveries:String = "deliveries"
    static let commonInterface:APIInterface = APIInterface()
    override init() {
        super.init()
    }
    fileprivate func prepareGetRequest(with params: [String:Int]?) -> URLRequest? {
        var queryString:String?
        if let params = params {
            queryString = ""
            for k in Array(params.keys){
                if let val = params[k]{
                    queryString = queryString! + "\(k)=\(val)"
                }
            }
        }
        var finalURLString = "\(self.baseURLPath)/\(self.endPointDeliveries)"
        if let queryString = queryString{
            finalURLString += "?\(queryString)"
        }
        if let url = URL(string: finalURLString){
            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0)
            return urlRequest
        }
        return nil
    }
    func requestDataForDeliveries(with params: [String:Int]?, and handler: @escaping APIInterfaceResponseBlock) {
        if let urlRequest = self.prepareGetRequest(with: params){
            let dataTaskDeliveries = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                handler(data, error)
            }
            dataTaskDeliveries.resume()
        }
    }
}
