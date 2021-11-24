//
//  AppDependencies.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 10/20/21.
//

import UIKit

class AppDependencies {
    @LateInit private var browserViewController: BrowserViewController
    
    lazy var tabsStorage: TabsStorage = {
        TabsStorageImpl()
    }()
    
    lazy var bookmarksStorage: BookmarksStorage = {
        BookmarksStorageImpl()
    }()

    init() {
        configureDependencies()
    }
    
    func installRootViewControllerIntoWindow(window: UIWindow?) {
        window?.rootViewController = browserViewController
        window?.makeKeyAndVisible()
    }

    private func configureDependencies() {
        self.browserViewController = createBrowserViewController()
    }
    
    func createBrowserViewController() -> BrowserViewController {
        let viewModel = BrowserViewModelImpl(bookmarksStorage: bookmarksStorage, tabsStorage: tabsStorage)
        return BrowserViewController(viewModel: viewModel, factory: self)
    }

    func createTabsViewController() -> TabsViewController {
        return TabsViewController(storage: tabsStorage)
    }
    
    func createBookmarksViewController(select: @escaping (URL) -> Void) -> BookmarksViewController {
        return BookmarksViewController(storage: bookmarksStorage, select: select)
    }
}

// can be split into two different protocols but for simplicity we merge them
protocol Storage {
    var tabsStorage: TabsStorage { get }
    var bookmarksStorage: BookmarksStorage { get }
}

protocol ViewControllerFactory {
    func createTabsViewController() -> TabsViewController
    func createBookmarksViewController(select: @escaping (URL) -> Void) -> BookmarksViewController
}
// pass around dependencies class but keep encapsulation
extension AppDependencies: ViewControllerFactory {}
extension AppDependencies: Storage {}
