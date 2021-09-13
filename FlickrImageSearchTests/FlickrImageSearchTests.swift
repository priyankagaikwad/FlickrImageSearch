//
//  FlickrImageSearchTests.swift
//  FlickrImageSearchTests
//
//  Created by Priyanka Gaikwad on 12/09/21.
//

import XCTest
@testable import FlickrImageSearch

class FlickrImageSearchTests: XCTestCase {

    var viewController:FISViewController!
    var window:UIWindow!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        window = UIWindow()
        viewController = FISViewController(nibName: nil, bundle: nil)
    }

    func testBaseURLStringIsCorrect() {
        let baseURLString = FISWorker().getSearchURL(searchText: "Kittens", pageCount: 1)!.absoluteString
          let expectedBaseURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=2932ade8b209152a7cbb49b631c4f9b6&%20format=json&nojsoncallback=1&safe_search=1&text=Kittens"
          XCTAssertEqual(baseURLString, expectedBaseURLString, "Base URL does not match expected base URL. Expected base URLs to match.")
      }
    
    func testPhotoURLStringIsCorrect() {
        let photo = Photo(id: "23451156376", owner: "28017113", secret: "8983a8ebc7", server: "578", farm: 1, title: "Merry Christmas!", ispublic: 1, isfriend: 0, isfamily: 0)

        let photoURLString = photo.getImagePath()
        let expectedPhotoURLString = "http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg"
          XCTAssertEqual(photoURLString, expectedPhotoURLString, "Photo URL does not match expected URL. Expected Photo URLs to match.")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        window = nil
        try super.tearDownWithError()
    }
    
    func testNumberOfRowsShouldEqualWithTotalMovies() {
        // Given
        let collectionView = viewController.collectionView
        loadView()
        
        // When
        let photos = [
            Photo(id: "23451156376", owner: "28017113", secret: "8983a8ebc7", server: "578", farm: 1, title: "Merry Christmas!", ispublic: 1, isfriend: 0, isfamily: 0),
            Photo(id: "23451156376", owner: "28017113", secret: "8983a8ebc7", server: "578", farm: 1, title: "Merry Christmas!", ispublic: 1, isfriend: 0, isfamily: 0)
        ]
        
        
        viewController.displayPhotos(images: photos)
        
        //Then
        let collectionViewRow = collectionView?.numberOfItems(inSection: 0)
        XCTAssertEqual(collectionViewRow, photos.count, "total items should be equal with total photos")
    }
    
    func loadView() {
           window.addSubview(viewController.view)
           RunLoop.current.run(until: Date())
    }

}
