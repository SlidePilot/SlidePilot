//
//  NavigationWindow.swift
//  SlidePilot
//
//  Created by Pascal Braband on 18.05.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import Cocoa

class NavigationWindow: NSWindow {
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 123 || event.keyCode == 126 || event.specialKey == NSEvent.SpecialKey.pageUp {
            PageController.previousPage(sender: self)
        } else if event.keyCode == 124 || event.keyCode == 125 || event.specialKey == NSEvent.SpecialKey.pageDown {
            PageController.nextPage(sender: self)
            if let appDelegate = NSApp.delegate as? AppDelegate {
                appDelegate.startTimerIfNeeded()
            }
        } else if event.specialKey == NSEvent.SpecialKey.home {
            PageController.firstPage(sender: self)
        } else if event.specialKey == NSEvent.SpecialKey.end {
            PageController.lastPage(sender: self)
        } else {
            super.keyDown(with: event)
        }
    }

}
