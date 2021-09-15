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
    func displayNoSearchResultFound()
}
class FISViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelInfo: UILabel!
    
    var interactor: FISInteractorDataLogic?
    private var photos: [Photo]?
    private var isFirstTime = true
    private var loader:UIActivityIndicatorView!
    
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
        loader = UIActivityIndicatorView(frame: self.view.frame)
        self.view.addSubview(loader)
        loader?.hidesWhenStopped = true

    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: FISConstants.CollectionViewCellNibId, bundle: nil), forCellWithReuseIdentifier: FISConstants.imageCollectionViewIdentifier)
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "Type to search photos..."
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
    
    private func resetCollectionView() {
        self.labelInfo.text = "Type to search photos..."
        photos?.removeAll()
        collectionView.reloadData()
        searchBar.becomeFirstResponder()
    }
    
    private func showLoader() {
        loader?.startAnimating()
        self.view.addSubview(loader!)
    }
    
    private func hideLoader() {
        loader?.stopAnimating()
        loader?.removeFromSuperview()
    }
}

extension FISViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        photos?.removeAll()
        if ((searchBar.text!.isEmpty)) {
            resetCollectionView()
            showAlert(title: "", message: "Please type in search box to see the result!!")
            return
        }
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
        self.labelInfo.text = "Loading photos..."
        showLoader()
        interactor?.search(text: text.removeSpecialChars)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            resetCollectionView()
        }
    }
}

//MARK: - Collection View DataSource
extension FISViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FISConstants.imageCollectionViewIdentifier, for: indexPath) as! CollectionViewCell
        guard let allPhotos = photos, allPhotos.count > 1 else { return cell }
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
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.hideLoader()
            weakSelf.labelInfo.text = ""
        }
        self.photos = images
        self.collectionView.reloadData()
    }
    
    func displayErrorMessage(error:String) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.hideLoader()
            weakSelf.labelInfo.text = ""
            weakSelf.showAlert(title: "Error", message: error)
        }
    }
    
    func displayNoSearchResultFound() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.hideLoader()
            weakSelf.labelInfo.text = "No data available for this search text. Please try different text!!"
        }
        self.collectionView.reloadData()
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
