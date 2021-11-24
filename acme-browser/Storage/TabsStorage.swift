//
//  TabsStorage.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 10/20/21.
//

protocol TabsStorage {
    func saveTab(tab: Tab)
    func getTabs() -> [Tab]
}

class TabsStorageImpl: TabsStorage {
    var tabs: [Tab] = []
    
    func getTabs() -> [Tab] {
        tabs
    }
    
    func saveTab(tab: Tab) {
        tabs.append(tab)
    }
}
