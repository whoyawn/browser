//
//  BrowserToolbar.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 11/13/21.
//

import UIKit

protocol BrowserToolbarDelegate: AnyObject {
    func didTapBack()
    func didTapForward()
    func didTapAdd()
    func didTapBookmarks()
    func didTapTabs()
}

class BrowserToolbar: UIToolbar {
    
    weak var toolbarDelegate: BrowserToolbarDelegate?
    
    lazy var backButton: UIBarButtonItem = {
        let image = UIImage(systemName: "chevron.backward")
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backTapped))
    }()
    
    lazy var forwardButton: UIBarButtonItem = {
        let image = UIImage(systemName: "chevron.forward")
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(forwardTapped))
    }()
    
    lazy var addButton: UIBarButtonItem = {
        let image = UIImage(systemName: "plus")
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
    }()
    
    lazy var bookmarksButton: UIBarButtonItem = {
        let image = UIImage(systemName: "book")
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(bookmarksTapped))
    }()
    
    lazy var tabsButton: UIBarButtonItem = {
        let image = UIImage(systemName: "rectangle.stack")
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tabsTapped))
    }()

    init() {
        // fix console dump (apple bug) https://stackoverflow.com/questions/58530406/unable-to-simultaneously-satisfy-constraints-when-uitoolbarcontentview-is-presen
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtons() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setItems([backButton, spacer, forwardButton, spacer, addButton, spacer, bookmarksButton, spacer, tabsButton], animated: false)
    }
    
    @objc func backTapped() {
        toolbarDelegate?.didTapBack()
    }
    
    @objc func forwardTapped() {
        toolbarDelegate?.didTapForward()
    }
    
    @objc func addTapped() {
        toolbarDelegate?.didTapAdd()
    }
    
    @objc func bookmarksTapped() {
        toolbarDelegate?.didTapBookmarks()
    }
    
    @objc func tabsTapped() {
        toolbarDelegate?.didTapTabs()
    }
    
}
