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
}

class FISPresenter: FISPresentationLogic {
    weak var viewController: FISDisplayLogic?
    
    func displayPhotos(photos: [Photo]) {
        DispatchQueue.main.async {
            self.viewController?.displayPhotos(images: photos)
        }
    }
    
    func displayErrorMessage(error: String) {
        viewController?.displayErrorMessage(error: error)
    }
}
