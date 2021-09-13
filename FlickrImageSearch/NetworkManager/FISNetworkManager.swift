//
//  FISNetworkManager.swift
//  FlickrImageSearch
//
//  Created by Priyanka Gaikwad on 12/09/21.
//

import Foundation
import UIKit

enum Result <T>{
    case Success(T)
    case Failure(String)
    case Error(String)
}

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    func request(_ request: NSMutableURLRequest, completion: @escaping (Result<Data>) -> Void) {
        guard (Reachability.currentReachabilityStatus != .notReachable) else {
            return completion(.Failure(FISConstants.noInternetConnection))
        }
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else {
                return completion(.Failure(error?.localizedDescription ?? FISConstants.errorMessage))
            }
            guard let data = data else {
                return completion(.Failure(error?.localizedDescription ?? FISConstants.errorMessage))
            }
            guard let stringResponse = String(data: data, encoding: String.Encoding.utf8) else {
                return completion(.Failure(error?.localizedDescription ?? FISConstants.errorMessage))
            }
//            print("Respone: \(stringResponse)")
            return completion(.Success(data))
            
        }.resume()
    }
    
    func downloadImage(_ urlString: String, completion: @escaping (Result<UIImage>) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        guard let url =  URL.init(string: urlString) else {
            return completion(.Failure(FISConstants.errorMessage))
        }
        
        guard (Reachability.currentReachabilityStatus != .notReachable) else {
            return completion(.Failure(FISConstants.noInternetConnection))
        }
        
        session.downloadTask(with: url) { (url, reponse, error) in
            do {
                guard let url = url else {
                    return completion(.Failure(FISConstants.errorMessage))
                }
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    return completion(.Success(image))
                } else {
                    return completion(.Failure(FISConstants.errorMessage))
                }
            } catch {
                return completion(.Error(FISConstants.errorMessage))
            }
        }.resume()
    }
}
