//
//  NetworkManager.swift
//  BaseMVVM
//
//  Created by Thulani Mtetwa on 2023/07/16.
//

import Foundation

protocol NetworkManagerProtocol {
    func getRequest(completion: @escaping (_ success: Bool, _ results: Posts?, _ error: String?) -> ())
}

class NetworkManager: NetworkManagerProtocol {
    func getRequest(completion: @escaping (Bool, Posts?, String?) -> ()) {
        HttpRequestHelper().GET(url: "https://jsonplaceholder.typicode.com/posts", params: ["": ""], httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(Posts.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Employees to model")
                }
            } else {
                completion(false, nil, "Error: Employees GET Request failed")
            }
        }
    }
}
