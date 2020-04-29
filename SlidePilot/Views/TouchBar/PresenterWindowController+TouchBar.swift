//
//  PresenterWindowController+TouchBar.swift
//  SlidePilot
//
//  Created by Pascal Braband on 28.04.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import Cocoa

@available(OSX 10.12.2, *)
extension PresenterWindowController: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        // Create TouchBar and assign delegate
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        
        
        touchBar.customizationIdentifier = .presentationBar
        touchBar.defaultItemIdentifiers = [.blackCurtainItem, .whiteCurtainItem, .notesItem, .navigatorItem, .fixedSpaceLarge, .pointerItem, .pointerAppearancePopover]
        touchBar.customizationAllowedItemIdentifiers = [.blackCurtainItem, .whiteCurtainItem, .notesItem, .navigatorItem, .fixedSpaceLarge, .pointerItem, .pointerAppearancePopover]
        
        // Subscribe to display changes
        DisplayController.subscribeDisplayNotes(target: self, action: #selector(displayNotesDidChangeTouchBar(_:)))
        DisplayController.subscribeDisplayBlackCurtain(target: self, action: #selector(displayBlackCurtainDidChangeTouchBar(_:)))
        DisplayController.subscribeDisplayWhiteCurtain(target: self, action: #selector(displayWhiteCurtainDidChangeTouchBar(_:)))
        DisplayController.subscribeDisplayNavigator(target: self, action: #selector(displayNavigatorDidChangeTouchBar(_:)))
        DisplayController.subscribeDisplayPointer(target: self, action: #selector(displayPointerDidChangeTouchBar(_:)))
        
        return touchBar
    }
    
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
            
        case .blackCurtainItem:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSSegmentedControl(
                images: [NSImage(named: "BlackCurtain")!],
                trackingMode: .selectAny,
                target: self,
                action: #selector(touchBarBlackCurtainPressed))
            item.view = button
            return item
            
        case .whiteCurtainItem:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSSegmentedControl(
                images: [NSImage(named: "WhiteCurtain")!],
                trackingMode: .selectAny,
                target: self,
                action: #selector(touchBarWhiteCurtainPressed(_:)))
            item.view = button
            return item
            
        case .notesItem:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSSegmentedControl(
                images: [NSImage(named: NSImage.touchBarTextListTemplateName)!],
                trackingMode: .selectAny,
                target: self,
                action: #selector(touchBarNotesPressed(_:)))
            item.view = button
            return item
            
        case .navigatorItem:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSSegmentedControl(
                images: [NSImage(named: NSImage.touchBarOpenInBrowserTemplateName)!],
                trackingMode: .selectAny,
                target: self,
                action: #selector(touchBarNavigatorPressed(_:)))
            item.view = button
            return item
            
            
        case .pointerItem:
            // Setup show/hide cursor button
            let item = NSCustomTouchBarItem(identifier: .pointerItem)
            let button = NSSegmentedControl(
                images: [NSImage(named: "Cursor")!],
                trackingMode: .selectAny,
                target: self,
                action: #selector(touchBarCursorPressed(_:)))
            item.view = button
            return item
            
        case .pointerAppearancePopover:
            // Setup appearance popover
            let appearancePopover = NSPopoverTouchBarItem(identifier: .pointerAppearancePopover)
            appearancePopover.showsCloseButton = true
            appearancePopover.collapsedRepresentationImage = NSImage(named: NSImage.touchBarQuickLookTemplateName)!
            let appearanceTouchBar = PointerAppearanceTouchBar()
            appearancePopover.pressAndHoldTouchBar = appearanceTouchBar
            appearancePopover.popoverTouchBar = appearanceTouchBar
            
            return appearancePopover
            
        default:
            return nil
        }
    }
    
    
    @objc func touchBarBlackCurtainPressed(_ sender: NSSegmentedControl) {
        DisplayController.switchDisplayBlackCurtain(sender: sender)
    }
    
    
    @objc func touchBarWhiteCurtainPressed(_ sender: NSSegmentedControl) {
        DisplayController.switchDisplayWhiteCurtain(sender: sender)
    }
    
    
    @objc func touchBarNotesPressed(_ sender: NSSegmentedControl) {
        DisplayController.switchDisplayNotes(sender: sender)
    }
    
    
    @objc func touchBarNavigatorPressed(_ sender: NSSegmentedControl) {
        DisplayController.switchDisplayNavigator(sender: sender)
    }
    
    
    @objc func touchBarCursorPressed(_ sender: NSSegmentedControl) {
        DisplayController.switchDisplayPointer(sender: sender)
    }
    
    
    @objc func touchBarCursorAppearancePressed(_ sender: NSButton) {
        print("cursor appearance")
    }
    
    
    
    // MARK: - Control Handlers
    
    @objc func displayNotesDidChangeTouchBar(_ notification: Notification) {
        // Set correct state for touch bar button
        guard let notesItem = self.touchBar?.item(forIdentifier: .notesItem) else { return }
        guard let notesButton = notesItem.view as? NSSegmentedControl else { return }
        
        setSelected(button: notesButton, DisplayController.areNotesDisplayed)
    }
    
    
    @objc func displayBlackCurtainDidChangeTouchBar(_ notification: Notification) {
        // Set correct state for touch bar button
        guard let blackCurtainItem = self.touchBar?.item(forIdentifier: .blackCurtainItem) else { return }
        guard let blackCurtainButton = blackCurtainItem.view as? NSSegmentedControl else { return }
        
        setSelected(button: blackCurtainButton, DisplayController.isBlackCurtainDisplayed)
    }
    
    
    @objc func displayWhiteCurtainDidChangeTouchBar(_ notification: Notification) {
        // Set correct state for touch bar button
        guard let whiteCurtainItem = self.touchBar?.item(forIdentifier: .whiteCurtainItem) else { return }
        guard let whiteCurtainButton = whiteCurtainItem.view as? NSSegmentedControl else { return }
        
        setSelected(button: whiteCurtainButton, DisplayController.isWhiteCurtainDisplayed)
    }
    
    
    @objc func displayNavigatorDidChangeTouchBar(_ notification: Notification) {
        // Set correct state for touch bar button
        guard let navigatorItem = self.touchBar?.item(forIdentifier: .navigatorItem) else { return }
        guard let navigatorButton = navigatorItem.view as? NSSegmentedControl else { return }
        
        setSelected(button: navigatorButton, DisplayController.isNavigatorDisplayed)
    }
    
    
    @objc func displayPointerDidChangeTouchBar(_ notification: Notification) {
        // Set correct state for touch bar button
        guard let pointerItem = self.touchBar?.item(forIdentifier: .pointerItem) else { return }
        guard let pointerButton = pointerItem.view as? NSSegmentedControl else { return }
        
        setSelected(button: pointerButton, DisplayController.isPointerDisplayed)
    }
    
    
    /**
     Selects/Deselect a button (in shape of an `NSSegmentedControl` with a single element) based on the condition.
    
     **NOTE**: `NSSegmentedControl` should only have one button.
    */
    private func setSelected(button: NSSegmentedControl, _ condition: Bool) {
        if condition {
            button.setSelected(true, forSegment: 0)
        } else {
            button.selectedSegment = -1
        }
    }
}
