//
//  TabsViewController.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 10/20/21.
//

import Foundation
import UIKit
import WebKit

protocol TabsDelegate: AnyObject {
    func didSelect(tab: Tab)
}

class TabsViewController: UITableViewController {
    let storage: TabsStorage
    weak var delegate: TabsDelegate?
    private var tabs: [Tab] = []
    // // MVC in interest of time, view model not necessary for this scope
    init(storage: TabsStorage) {
        self.storage = storage
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabs = storage.getTabs()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tabs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier) else {
            assertionFailure("Could not cast to UITableViewCell")
            return UITableViewCell()
        }
        cell.configure(with: tabs[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tab = tabs[indexPath.row]
        dismiss(animated: true) {
            // Need to retain self until the parent is done executing this statement
            self.delegate?.didSelect(tab: tab)
        }
    }
}

extension UITableViewCell {
    func configure(with tab: Tab) {
        var content = defaultContentConfiguration()
        content.text = (tab.webView.url?.host ?? "") + (tab.webView.url?.path ?? "")
        contentConfiguration = content
    }
}
