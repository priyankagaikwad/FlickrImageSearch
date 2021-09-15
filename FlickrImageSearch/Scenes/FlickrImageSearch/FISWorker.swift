//
//  FISWorker.swift
//  FlickrImageSearch
//
//  Created by Priyanka Gaikwad on 12/09/21.
//

import Foundation

class FISWorker: NSObject {
    
    // Generate search URL
    func getSearchURL(searchText:String, pageCount:Int) -> URL? {
        let urlString = "\(FISConstants.apiUrl)&api_key=\(FISConstants.apiKey)&%20format=json&nojsoncallback=1&safe_search=\(pageCount)&text=\(searchText)"
        guard let searchURL = URL(string: urlString) else {
            debugPrint("Invalid url string", urlString)
            return nil
        }
        return searchURL
    }
    
    func request(_ searchText: String, pageNo: Int, completion: @escaping (Result<Photos?>) -> Void) {
        
        guard let requestURL = createSearchRequest(searchText: searchText, pageNo: pageNo) else {
            return
        }
    
        NetworkManager.shared.request(requestURL) { (result) in
            switch result {
            case .Success(let responseData):
                if let response = self.processResponse(responseData) {
                     return response.stat.uppercased().contains("OK") ? completion(.Success(response.photos)) : completion(.Failure(FISConstants.errorMessage))
                } else {
                    return completion(.Failure(FISConstants.errorMessage))
                }
            case .Failure(let message):
                return completion(.Failure(message))
            case .Error(let error):
                return completion(.Failure(error))
            }
        }
    }
    
    func processResponse(_ data: Data) -> FlickrPhotos? {
        do {
            let responseModel = try JSONDecoder().decode(FlickrPhotos.self, from: data)
            return responseModel
            
        } catch(let error) {
            print(error)
            return nil
        }
    }
    
    func createSearchRequest(searchText:String, pageNo:Int, bodyParams: [String: Any]? = nil) -> NSMutableURLRequest? {
        guard let urlString = getSearchURL(searchText: searchText, pageCount: pageNo) else { return nil }
        let request = NSMutableURLRequest(url: urlString)
        do {
            if let bodyParams = bodyParams {
                let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                request.httpBody = data
            }
        } catch(let error) {
            print("Invalid Request", error)
            return nil

        }
        request.httpMethod = HttpMethod.get.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}

