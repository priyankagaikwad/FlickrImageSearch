//
//  ViewController.swift
//  FlickrImageSearch
//
//  Created by Priyanka Gaikwad on 12/09/21.
//

import UIKit

protocol FISDisplayLogic: AnyObject {
    func displayPhotos(images: [Photo])
    func displayErrorMessage(error:String)
}
class FISViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelInfo: UILabel!
    
    var interactor: FISInteractorDataLogic?
    private var photos: [Photo]?
    private var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        configureCollectionView()
        configureSearchBar()
        setupDelegates()
    }
    
    private func configureUI() {
        navigationController?.title = FISConstants.appTitle
        self.view.bringSubviewToFront(self.labelInfo)
        self.labelInfo.text = "Type to search photos..."
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: FISConstants.CollectionViewCellNibId, bundle: nil), forCellWithReuseIdentifier: FISConstants.imageCollectionViewIdentifier)
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        
        if isFirstTime {
            searchBar.becomeFirstResponder()
            isFirstTime = false
        }
    }
    
    private func setupDelegates() {
        let viewController = self
        let interactor = FISInteractor()
        let presenter = FISPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
}

extension FISViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        photos?.removeAll()
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
        self.labelInfo.text = "Loading photos..."
        interactor?.search(text: text.removeSpecialChars)
    }
}

//MARK: - Collection View DataSource
extension FISViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FISConstants.imageCollectionViewIdentifier, for: indexPath) as! CollectionViewCell
        guard let allPhotos = photos else { return cell }
        guard let imagePath = allPhotos[indexPath.row].getImagePath() else {
            return cell
        }
        cell.configureCell(imagePath)
        if indexPath.row == (allPhotos.count - 10) {
            interactor?.fetchNextPage()
        }
        return cell
    }
}

extension FISViewController: FISDisplayLogic {
    func displayPhotos(images: [Photo]) {
        self.labelInfo.text = ""
        self.photos = images
        self.collectionView.reloadData()
    }
    
    func displayErrorMessage(error:String) {
        DispatchQueue.main.async {
            self.labelInfo.text = ""
            self.showAlert(title: "Error", message: error)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FISViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/3.0, height: (collectionView.bounds.width)/3.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
