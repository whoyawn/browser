//
//  BrowserViewModel.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 11/21/21.
//

import Combine
import Foundation
import UIKit

protocol BrowserViewModel {
    var pageIsBookmarked: CurrentValueSubject<Bool, Never> { get }
    func convertToURLRequest(text: String) -> URLRequest
    func saveTab(tab: Tab)
    func saveBookmark(url: URL)
    func removeBookmark(url: URL)
    func urlDidLoad(url: URL)
}

struct BrowserViewModelImpl: BrowserViewModel {
    // Simplifies the downstream data retrieval, since the view controller only needs to subscribe once, we can have different mutating methods update this value
    var pageIsBookmarked: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let bookmarksStorage: BookmarksStorage
    let tabsStorage: TabsStorage
    
    init(bookmarksStorage: BookmarksStorage, tabsStorage: TabsStorage) {
        self.bookmarksStorage = bookmarksStorage
        self.tabsStorage = tabsStorage
    }
    // Can optionally inject a favorite search engine. Also use a crude validator / sanitizer that handles http to https and defaulting to search engines if it doesn't end in .*
    func convertToURLRequest(text: String) -> URLRequest {
        let searchString = "https://duckduckgo.com/?q=\(text)"
        var sanitizedText = text
            .replacingOccurrences(of: "http:", with: "https:")
            .lowercased()
        // If it's a domain in the form people generally speak like "neeva.com", then add https://
        if !sanitizedText.hasPrefix("https://") && sanitizedText.range(of: #"\.[a-z]{2,6}"#, options: .regularExpression) != nil {
            sanitizedText = "https://" + sanitizedText
        }
        // Can inject UIApplication here if needed
        guard let url = URL(string: sanitizedText), UIApplication.shared.canOpenURL(url) else {
            return URLRequest(url: URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")!)
        }
        return URLRequest(url: url)
    }
    
    func saveTab(tab: Tab) {
        tabsStorage.saveTab(tab: tab)
    }
    // In production, we could store a string too if we wanted and convert it back and forth in the view controller, but for simplicity iIm storing the url type
    func saveBookmark(url: URL) {
        bookmarksStorage.saveUrl(url: url)
        pageIsBookmarked.send(true)
    }
    
    func removeBookmark(url: URL) {
        bookmarksStorage.removeUrl(url: url)
        pageIsBookmarked.send(false)
    }
    
    func urlDidLoad(url: URL) {
        pageIsBookmarked.send(bookmarksStorage.urls.contains(url))
    }
    
}
