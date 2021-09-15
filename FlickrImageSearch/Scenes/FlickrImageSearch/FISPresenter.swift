//
//  FISPresenter.swift
//  FlickrImageSearch
//
//  Created by Priyanka Gaikwad on 12/09/21.
//

import Foundation

protocol FISPresentationLogic {
    func displayPhotos(photos: [Photo])
    func displayErrorMessage(error: String)
    func displayNoSearchResultFound()
}

class FISPresenter: FISPresentationLogic {
    weak var viewController: FISDisplayLogic?
    
    func displayPhotos(photos: [Photo]) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.viewController?.displayPhotos(images: photos)
        }
    }
    
    func displayErrorMessage(error: String) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.viewController?.displayErrorMessage(error: error)
        }
    }
    
    func displayNoSearchResultFound() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.viewController?.displayNoSearchResultFound()
        }
    }
}
