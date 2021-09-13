//
//  ViewController.swift
//  FlickrImageSearch
//
//  Created by synerzip on 12/09/21.
//

import UIKit

class FISViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension FISViewController: UISearchBarDelegate {
    // MARK: SearchBar delegates
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
        collectionView.reloadData()
        viewModel.search(text: text) {
            print("search completed.")
        }
        searchBar.resignFirstResponder()
    }
}

