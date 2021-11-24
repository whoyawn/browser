//
//  BookmarksStorage.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 10/20/21.
//

import Foundation

protocol BookmarksStorage {
    // can be also implemented as dict but we want bookmarks added in order
    var urls: [URL] { get set }
    func saveUrl(url: URL)
    func removeUrl(url: URL)
}

class BookmarksStorageImpl: BookmarksStorage {
    var urls = [URL]()
    
    func saveUrl(url: URL) {
        urls.append(url)
    }
    
    func removeUrl(url: URL) {
        urls.removeAll(where: { $0 == url })
    }
}

