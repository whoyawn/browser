//
//  BrowserViewController.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 10/20/21.
//

import Combine
import UIKit
import WebKit

class BrowserViewController: UIViewController {
    
    lazy var browserView: BrowserView = {
        BrowserView()
    }()
    let viewModel: BrowserViewModel
    let factory: ViewControllerFactory
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: BrowserViewModel, factory: ViewControllerFactory) {
        self.viewModel = viewModel
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
        // normally we'll have a start page, but because that's out of scope, save the first created tab upon launch
        let id = BrowserViewController.generateId()
        viewModel.saveTab(tab: Tab(id: id, webView: browserView.webView))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = browserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBrowserView(browserView)
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.pageIsBookmarked
            .receive(on: RunLoop.main)
            .sink { [weak self] isBookmarked in
                self?.browserView.urlBar.isPageBookmarked = isBookmarked
        }.store(in: &cancellables)
    }
    
    func createTab() {
        let browserView = BrowserView()
        let id = BrowserViewController.generateId()
        viewModel.saveTab(tab: Tab(id: id, webView: browserView.webView))
        self.browserView = browserView
        view = browserView
        configureBrowserView(browserView)
    }
    
    func configureBrowserView(_ browserView: BrowserView) {
        browserView.delegate = self
        browserView.urlBar.delegate = self
        browserView.toolbar.toolbarDelegate = self
    }
    
    func loadURL(_ url: URL) {
        browserView.webView.load(URLRequest(url: url))
    }
    
    static func generateId() -> String {
        // For convenience, normally we don't want to be generating our own ids here in this view controller
        return String(Date().timeIntervalSince1970)
    }
    
    deinit {
        cancellables.removeAll()
    }
    
}

extension BrowserViewController: BrowserToolbarDelegate {
    func didTapBack() {
        browserView.webView.goBack()
    }
    
    func didTapForward() {
        browserView.webView.goForward()
    }
    
    func didTapAdd() {
        createTab()
    }
    
    func didTapBookmarks() {
        // closure injection if we want to be more explicit/fewers callback
        let viewController = factory.createBookmarksViewController { [weak self] url in
            self?.loadURL(url)
        }
        // decouples need to know what the parent controller is
        showDetailViewController(viewController, sender: self)
    }
    
    func didTapTabs() {
        let viewController = factory.createTabsViewController()
        // Could also be just a closure or passed in the factory method if we wanted the dependency more explicit
        viewController.delegate = self
        showDetailViewController(viewController, sender: self)
    }
}

extension BrowserViewController: TabsDelegate {
    func didSelect(tab: Tab) {
        let browserView = BrowserView(webView: tab.webView)
        configureBrowserView(browserView)
        self.browserView = browserView
        view = browserView
    }
}

extension BrowserViewController: BrowserDelegate {
    func urlDidLoad(url: URL) {
        viewModel.urlDidLoad(url: url)
    }
}

extension BrowserViewController: URLBarDelegate {
    func didTapBookmark(isBookmarked: Bool) {
        // should use web view as source of truth for current url
        guard let url = browserView.webView.url else { return }
        if !isBookmarked {
            viewModel.saveBookmark(url: url)
        } else {
            viewModel.removeBookmark(url: url)
        }
    }
    
    func didTapRefresh() {
        browserView.webView.reload()
    }
    
    func didSubmitText(text: String) {
        let request = viewModel.convertToURLRequest(text: text)
        browserView.webView.load(request)
    }
}
