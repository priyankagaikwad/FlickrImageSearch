//
//  FISInteractor.swift
//  FlickrImageSearch
//
//  Created by Priyanka Gaikwad on 12/09/21.
//

import Foundation

protocol FISInteractorDataLogic: AnyObject {
    func search(text:String)
    func fetchNextPage()
}

class FISInteractor: FISInteractorDataLogic {
    var presenter: FISPresentationLogic?
    
    private(set) var photoArray = [Photo]()
    private var searchText = ""
    private var pageNo = 1
    private var totalPageNo = 1
    
    func search(text:String) {
        searchText = text
        pageNo = 1
        photoArray.removeAll()
        fetchSearchImages()
    }
    
    func fetchSearchImages() {
        FISWorker().request(searchText, pageNo: pageNo) { (result) in
            DispatchQueue.main.async {[weak self] in
                guard let weakSelf = self else {return}
                switch result {
                case .Success(let results):
                    if let result = results {
                        weakSelf.totalPageNo = result.pages
                        weakSelf.photoArray.append(contentsOf:result.photo)
                        if weakSelf.photoArray.count < 1 {
                            weakSelf.presenter?.displayNoSearchResultFound()
                        } else {
                            weakSelf.presenter?.displayPhotos(photos: weakSelf.photoArray)
                        }
                    }
                case .Failure(let message):
                    weakSelf.presenter?.displayErrorMessage(error: message.description)
                case .Error(let error):
                    if weakSelf.pageNo > 1 {
                        weakSelf.presenter?.displayErrorMessage(error: error)
                    }
                }
            }
        }
    }
    
    func fetchNextPage() {
        if pageNo < totalPageNo {
            pageNo += 1
            fetchSearchImages()
        }
    }
    
    
}
