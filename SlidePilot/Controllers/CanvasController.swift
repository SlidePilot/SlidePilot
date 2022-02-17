//
//  CanvasController.swift
//  SlidePilot
//
//  Created by Pascal Braband on 10.06.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import Cocoa

class CanvasController: NSObject {
    
    public private(set) static var drawingColor: NSColor = .black
    public static var canvasBackgroundColor: NSColor { return DocumentController.drawings[PageController.currentPage]?.backgroundColor ?? .clear }
    
    public static var isCanvasBackgroundTransparent: Bool {
        return canvasBackgroundColor == .clear
    }
    
    
    // MARK: - Senders
    
    /** Sends a notification, that the drawing color was changed increased. */
    public static func setDrawingColor(to newColor: NSColor, sender: Any?) {
        self.drawingColor = newColor
        NotificationCenter.default.post(name: .didChangeDrawingColor, object: sender)
    }
    
    
    /** Clears the canvas and sends a notification. */
    public static func clearCanvas(sender: Any?) {
        NotificationCenter.default.post(name: .didClearCurrentCanvas, object: sender)
    }
    
    
    /** Changes the background color of the current drawing. */
    public static func setCanvasBackground(to color: NSColor, sender: Any?) {
        NotificationCenter.default.post(name: .didChangeCanvasBackground, object: sender, userInfo: ["color": color])
    }
    
    
    /** Sets the canvas background to either transparent or blank. */
    public static func setTransparentCanvasBackground(_ isTransparent: Bool, sender: Any?) {
        if isTransparent {
            setCanvasBackground(to: .clear, sender: self)
        } else {
            setCanvasBackground(to: .white, sender: self)
        }
    }
    
    
    /** Changes transparent canvas to the opposite and sends notification, that this property changed. */
    public static func switchTransparentCanvas(sender: Any?) {
        setTransparentCanvasBackground(!isCanvasBackgroundTransparent, sender: sender)
    }
    
    
    
    // MARK: - Subscribe
    
    /** Subscribes a target to all `.didChangeDrawingColor` notifications sent by `CanvasController`. */
    public static func subscribeDrawingColorChanged(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .didChangeDrawingColor, object: nil)
    }
    
    
    /** Subscribes a target to all `.didClearCurrentCanvas` notifications sent by `CanvasController`. */
    public static func subscribeClearCanvas(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .didClearCurrentCanvas, object: nil)
    }
    
    
    /** Subscribes a target to all `.didChangeCanvasBackground` notifications sent by `CanvasController`. */
    public static func subscribeCanvasBackgroundChanged(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .didChangeCanvasBackground, object: nil)
    }
    
    
    /** Unsubscribes a target from all notifications sent by `PageController`. */
    public static func unsubscribe(target: Any) {
        NotificationCenter.default.removeObserver(target, name: .didChangeDrawingColor, object: nil)
        NotificationCenter.default.removeObserver(target, name: .didClearCurrentCanvas, object: nil)
        NotificationCenter.default.removeObserver(target, name: .didChangeCanvasBackground, object: nil)
    }
}




extension Notification.Name {
    static let didChangeDrawingColor = Notification.Name("didChangeDrawingColor")
    static let didClearCurrentCanvas = Notification.Name("didClearCurrentCanvas")
    static let didChangeCanvasBackground = Notification.Name("didChangeCanvasBackground")
}
