//
//  ImageDownloadOperation.swift
//  FlickrImageSearch
//
//  Created by Priyanka Gaikwad on 12/09/21.
//

import Foundation
import UIKit

typealias ImageCompletion = (_ image : UIImage?, _ url : String) -> Void

class ImageDownloadOperation: Operation {
    
    let url: String?
    var customCompletionBlock: ImageCompletion?
    
    init(url: String, completionBlock: @escaping ImageCompletion) {
        self.url = url
        self.customCompletionBlock = completionBlock
    }
    
    override func main() {
        if self.isCancelled { return }
        if let url = self.url {
            if self.isCancelled { return }
            NetworkManager.shared.downloadImage(url) { (result) in
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {return}
                    switch result {
                    case .Success(let image):
                        if weakSelf.isCancelled { return }
                        if let completion = weakSelf.customCompletionBlock{
                            completion(image, url)
                        }
                    default:
                        if weakSelf.isCancelled { return }
                        break
                    }
                }
            }
        }
    }
}

