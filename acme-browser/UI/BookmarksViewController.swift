//
//  BookmarksViewController.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 10/20/21.
//

import Foundation
import UIKit

extension UITableViewCell: ReuseIdentifiable {}
/// Allows a type to return a string denoting its class name.
/// Use when configuring a dequeable cell such as `UITableViewCell` and `UICollectionViewCell`.
protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell {
    func configure(with bookmark: URL) {
        var content = defaultContentConfiguration()
        content.text = (bookmark.host ?? "") + bookmark.path
        contentConfiguration = content
    }
}

// Optional way to declare a data source
class BookmarksTableViewDataSource: NSObject, UITableViewDataSource {
    // Shortcut, normally we would use a custom Bookmark type
    var bookmarks = [URL]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier) else {
            assertionFailure("Could not cast to UITableViewCell")
            return UITableViewCell()
        }
        let bookmark = bookmarks[indexPath.row]
        cell.configure(with: bookmark)
        return cell
    }
    
}

class BookmarksViewController: UITableViewController {
    
    let storage: BookmarksStorage
    let select: (URL) -> Void
    var dataSource = BookmarksTableViewDataSource()
    // MVC in interest of time, view model not necessary for this scope
    init(storage: BookmarksStorage, select: @escaping (URL) -> Void) {
        self.storage = storage
        self.select = select
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        dataSource.bookmarks = storage.urls
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmark = dataSource.bookmarks[indexPath.row]
        dismiss(animated: true) {
            // Need to retain self until the parent is done executing this statement
            self.select(bookmark)
        }
    }
}
