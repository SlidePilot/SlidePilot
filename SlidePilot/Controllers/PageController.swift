//
//  Notification-Name+Extension.swift
//  SlidePilot
//
//  Created by Pascal Braband on 24.04.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import Foundation

class PageController {
    
    public private(set) static var currentPage = 0
    
    
    /** Sends a notification, that the next page was selected. */
    public static func nextPage(sender: Any?) {
        selectPage(at: currentPage+1, sender: sender)
    }
    
    
    /** Sends a notification, that the previous page was selected. */
    public static func previousPage(sender: Any?) {
        selectPage(at: currentPage-1, sender: sender)
    }
    
    
    /** Sends a notification, that the page was changed. With the corresponding page as user info. */
    public static func selectPage(at index: Int, sender: Any?) {
        if isValidIndex(index) {
            NotificationCenter.default.post(name: .willSelectPage, object: sender)
            currentPage = index
            NotificationCenter.default.post(name: .didSelectPage, object: sender)
        }
    }
    
    
    private static func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < DocumentController.pageCount
    }
    
    
    /** Subscribes a target to all `.didSelectPage` notifications sent by `PageController`. */
    public static func subscribeDidSelectPage(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .didSelectPage, object: nil)
    }
    
    
    /** Subscribes a target to all `.willSelectPage` notifications sent by `PageController`. */
    public static func subscribeWillSelectPage(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .willSelectPage, object: nil)
    }
    
    
    /** Unsubscribes a target from all notifications sent by `PageController`. */
    public static func unsubscribe(target: Any) {
        NotificationCenter.default.removeObserver(target, name: .didSelectPage, object: nil)
        NotificationCenter.default.removeObserver(target, name: .willSelectPage, object: nil)
    }
}




extension Notification.Name {
    static let willSelectPage = Notification.Name("willSelectPage")
    static let didSelectPage = Notification.Name("didSelectPage")
}
