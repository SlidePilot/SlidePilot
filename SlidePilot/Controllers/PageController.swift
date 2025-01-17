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
    
    /** Stores the previously selected page. This is not necessarily the current page - 1, because jumps are possible. */
    public private(set) static var previousPage = 0
    
    public private(set) static var isPageSwitchingEnabled = true
    
    
    /** Enables/disables being able to switch pages. */
    public static func enablePageSwitching(_ isEnabled: Bool, sender: Any?) {
        isPageSwitchingEnabled = isEnabled
        NotificationCenter.default.post(name: .didChangePageSwitchingEnabled, object: sender)
    }
    
    
    
    /** Sends a notification, that the next page was selected. */
    public static func nextPage(sender: Any?) {
        selectPage(at: currentPage+1, sender: sender)
    }
    
    
    /** Sends a notification, that the previous page was selected. */
    public static func previousPage(sender: Any?) {
        selectPage(at: currentPage-1, sender: sender)
    }
    
    /** Sends a notification, that the first page was selected. */
    public static func firstPage(sender: Any?) {
        selectPage(at: 0, sender: sender)
    }
    
    /** Sends a notification, that the last page was selected. */
    public static func lastPage(sender: Any?) {
        selectPage(at: DocumentController.pageCount-1, sender: sender)
    }
    
    /** Sends a notification, that the page was changed. With the corresponding page as user info. */
    public static func selectPage(at index: Int, sender: Any?) {
        // Only continue if page switching is enabled
        guard isPageSwitchingEnabled else { return }
        
        if isValidIndex(index) {
            previousPage = currentPage
            currentPage = index
            NotificationCenter.default.post(name: .didSelectPage, object: sender)
        }
    }
    
    
    /** Selects the previous page and sends a notification, that the page was changed. */
    public static func selectPreviousPage(sender: Any?) {
        selectPage(at: previousPage, sender: sender)
    }
    
    
    private static func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < DocumentController.pageCount
    }
    
    
    /** Subscribes a target to all `.didSelectPage` notifications sent by `PageController`. */
    public static func subscribe(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .didSelectPage, object: nil)
    }
    
    
    /** Subscribes a target to all `.didChangePageSwitchingEnabled` notification sent by `PageController`. */
    public static func subscribePageSwitchingEnabled(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .didChangePageSwitchingEnabled, object: nil)
    }
    
    
    /** Unsubscribes a target from all notifications sent by `PageController`. */
    public static func unsubscribe(target: Any) {
        NotificationCenter.default.removeObserver(target, name: .didSelectPage, object: nil)
        NotificationCenter.default.removeObserver(target, name: .didChangePageSwitchingEnabled, object: nil)
    }
}




extension Notification.Name {
    static let didSelectPage = Notification.Name("didSelectPage")
    static let didChangePageSwitchingEnabled = Notification.Name("didChangePageSwitchingEnabled")
}
