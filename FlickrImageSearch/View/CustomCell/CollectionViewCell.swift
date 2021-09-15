//
//  CollectionViewCell.swift
//  FlickrImageSearch
//
//  Created by Priyanka Gaikwad on 11/09/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(_ imageUrl: String) {
        imageView.image = UIImage(imageLiteralResourceName: "placeholder")
        downloadImage(imageUrl)
    }
    
    func downloadImage(_ imagePath: String?) {
        guard let path = imagePath else {
            return
        }
        ImageDownloadManager.shared.addOperation(url: path, imageView: imageView) {  [weak self](result,downloadedImageURL)  in
            DispatchQueue.main.async {[weak self] in
                guard let weakSelf = self else {return}
                switch result {
                case .Success(let image):
                    weakSelf.imageView.image = image
                case .Failure(_):
                    break
                case .Error(_):
                    break
                }
            }
        }
    }
}
