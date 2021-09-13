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
            DispatchQueue.main.async {
                switch result {
                case .Success(let results):
                    if let result = results {
                        self.totalPageNo = result.pages
                        self.photoArray.append(contentsOf:result.photo)
                        self.presenter?.displayPhotos(photos: self.photoArray)
                    }
                case .Failure(let message):
                    self.presenter?.displayErrorMessage(error: message.description)
                case .Error(let error):
                    if self.pageNo > 1 {
                        self.presenter?.displayErrorMessage(error: error)
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
