//
//  DocumentController.swift
//  SlidePilot
//
//  Created by Pascal Braband on 24.04.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import Foundation
import PDFKit

class DocumentController {
    
    public private(set) static var document: PDFDocument?
    
    /** Returns the number of pages in the current document */
    public static var pageCount: Int {
        return document?.pageCount ?? 0
    }
    
    
    /** Sends a notification, that the document was changed. */
    public static func setDocument(_ document: PDFDocument, sender: Any) {
        self.document = document
        NotificationCenter.default.post(name: .didOpenDocument, object: sender)
    }
    
    
    /** Sends a notification, that saving the document was requested. */
    public static func requestSaveDocument(sender: Any) {
        NotificationCenter.default.post(name: .requestSaveDocument, object: sender)
    }
    
    
    /** Sends a notification, that saving the document was saved with success value. */
    public static func didSaveDocument(success: Bool, sender: Any) {
        NotificationCenter.default.post(name: .didSaveDocument, object: sender, userInfo: ["success": success])
    }
    
    
    /** Sends a notification, that the document was edited. */
    public static func didEditDocument(success: Bool, sender: Any) {
        NotificationCenter.default.post(name: .didEditDocument, object: sender)
    }
    
    
    /** Sends a notification, that importing notes from annotations was requested. */
    public static func requestImportNotesFromAnnotations(success: Bool, sender: Any) {
        NotificationCenter.default.post(name: .requestImportNotesFromAnnotations, object: sender)
    }
    
    
    /** Sends a notification, that importing notes from file was requested. */
    public static func requestImportNotesFromFile(success: Bool, sender: Any) {
        NotificationCenter.default.post(name: .requestImportNotesFromFile, object: sender)
    }
    
    
    /** Sends a notification, that exporting notes to file was requested. */
    public static func requestExportNotesToFile(success: Bool, sender: Any) {
        NotificationCenter.default.post(name: .requestExportNotesToFile, object: sender)
    }
    
    
    /** Sends a notification, that importing notes finished with success value. */
    public static func finishedImportingNotes(success: Bool, sender: Any) {
        NotificationCenter.default.post(name: .didImportNotes, object: sender, userInfo: ["success": success])
    }
    
    
    /** Sends a notification, that exporting notes finished with success value. */
    public static func finishedExportingNotes(success: Bool, sender: Any) {
        NotificationCenter.default.post(name: .didExportNotes, object: sender, userInfo: ["success": success])
    }
    
    
    /** Subscribes a target to all `.didOpenDocument` notifications sent by `DocumentController`. */
    public static func subscribeDidOpenDocument(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .didOpenDocument, object: nil)
    }
    
    
    /** Subscribes a target to all `.requestSaveDocument` notifications sent by `DocumentController`. */
    public static func subscribeRequestSaveDocument(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .requestSaveDocument, object: nil)
    }
    
    
    /** Subscribes a target to all `.didSaveDocument` notifications sent by `DocumentController`. */
    public static func subscribeDidSaveDocument(success: Bool, target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name:  .didSaveDocument, object: nil)
    }
    
    
    /** Subscribes a target to all `.didEditDocument` notifications sent by `DocumentController`. */
    public static func subscribeDidEditDocument(success: Bool, target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .didEditDocument, object: nil)
    }
    
    
    /** Subscribes a target to all `.requestImportNotesFromAnnotations` notifications sent by `DocumentController`. */
    public static func subscribeRequestImportNotesFromAnnotations(success: Bool, target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .requestImportNotesFromAnnotations, object: nil)
    }
    
    
    /** Subscribes a target to all `.requestImportNotesFromFile` notifications sent by `DocumentController`. */
    public static func subscribeRequestImportNotesFromFile(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .requestImportNotesFromFile, object: nil)
    }
    
    
    /** Subscribes a target to all `.requestExportNotesToFile` notifications sent by `DocumentController`. */
    public static func subscribeRequestExportNotesToFile(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .requestExportNotesToFile, object: nil)
    }
    
    
    /** Subscribes a target to all `.didImportNotes` notifications sent by `DocumentController`. */
    public static func subscribeFinishedImportingNotes(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .didImportNotes, object: nil)
    }
    
    
    /** Subscribes a target to all `.didExportNotes` notifications sent by `DocumentController`. */
    public static func subscribeFinishedExportingNotes(target: Any, action: Selector) {
        NotificationCenter.default.addObserver(target, selector: action, name: .didExportNotes, object: nil)
    }
    
    
    /** Unsubscribes a target from all notifications sent by `DocumentController`. */
    public static func unsubscribe(target: Any) {
        NotificationCenter.default.removeObserver(target, name: .didOpenDocument, object: nil)
        NotificationCenter.default.removeObserver(target, name: .didOpenDocument, object: nil)
        NotificationCenter.default.removeObserver(target, name: .requestSaveDocument, object: nil)
        NotificationCenter.default.removeObserver(target, name: .didSaveDocument, object: nil)
        NotificationCenter.default.removeObserver(target, name: .didEditDocument, object: nil)
        NotificationCenter.default.removeObserver(target, name: .requestImportNotesFromAnnotations, object: nil)
        NotificationCenter.default.removeObserver(target, name: .requestImportNotesFromFile, object: nil)
        NotificationCenter.default.removeObserver(target, name: .requestExportNotesToFile, object: nil)
        NotificationCenter.default.removeObserver(target, name: .didImportNotes, object: nil)
        NotificationCenter.default.removeObserver(target, name: .didExportNotes, object: nil)
    }
}




extension Notification.Name {
    static let didOpenDocument = Notification.Name("didOpenDocument")
    static let requestSaveDocument = Notification.Name("requestSaveDocument")
    static let didSaveDocument = Notification.Name("didSaveDocument")
    static let didEditDocument = Notification.Name("didEditDocument")
    static let requestImportNotesFromAnnotations = Notification.Name("requestImportNotesFromAnnotations")
    static let requestImportNotesFromFile = Notification.Name("requestImportNotesFromFile")
    static let requestExportNotesToFile = Notification.Name("requestExportNotesToFile")
    static let didImportNotes = Notification.Name("didImportNotes")
    static let didExportNotes = Notification.Name("didExportNotes")
}
