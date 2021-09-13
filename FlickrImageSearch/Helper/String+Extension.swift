//
//  String+Extension.swift
//  FlickrImageSearch
//
//  Created by Priyanka Gaikwad on 13/09/21.
//

import Foundation

extension String {
    var removeSpecialChars: String {
            let allowedChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
            return self.filter {allowedChars.contains($0) }
        }
}
