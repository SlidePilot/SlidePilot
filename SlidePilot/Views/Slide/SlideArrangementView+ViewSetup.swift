//
//  SlideArrangementView+ViewSetup.swift
//  SlidePilot
//
//  Created by Pascal Braband on 02.05.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import Cocoa

// This extension contains all the UI code for the different view setups
extension SlideArrangementView {
    
    func setupLayout(displayNext: Bool, displayNotes: Bool, notesMode: DisplayController.NotesMode) {
        willSwitchLayout()
        
        clearView()
        if displayNext == false, displayNotes == false {
            setupSlidesLayoutCurrent()
        } else if displayNext == true, displayNotes == false {
            setupSlidesLayoutCurrentNext()
        } else if displayNext == true, displayNotes == true, notesMode == .split {
            setupSlidesLayoutCurrentNextNotes()
        } else if displayNext == false, displayNotes == true, notesMode == .split {
            setupSlidesLayoutCurrentNotes()
        } else if displayNext == true, displayNotes == true, notesMode == .text {
            setupSlidesLayoutCurrentNextNotesText()
        } else if displayNext == false, displayNotes == true, notesMode == .text {
            setupSlidesLayoutCurrentNotesText()
        }
    }
    
    
    private func willSwitchLayout() {
        // Switching layout may remove subviews
        // Put all actions that need to be done before that in here
    }
    
    
    private func clearView() {
        // Remove all subviews, but keep split view
        self.subviews.forEach({
            if $0 != splitView {
                $0.removeFromSuperview()
            }
        })
        
        // Remove all subviews from split view containers
        leftContainer!.subviews.forEach({ $0.removeFromSuperview() })
        rightContainer!.subviews.forEach({ $0.removeFromSuperview() })
        
        // Remove references to views
        notesEditor = nil
    }
    
    
    func setupSplitView() {
        splitView = SplitView(frame: self.frame)
        splitView!.dividerStyle = .thin
        splitView!.isVertical = true
        splitView!.setDividerColor(DividerColor)
        
        splitView!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(splitView!)
        self.addConstraints([NSLayoutConstraint(item: splitView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
                             NSLayoutConstraint(item: splitView!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
                             NSLayoutConstraint(item: splitView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                             NSLayoutConstraint(item: splitView!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)])
        
        leftContainer = NSView(frame: .zero)
        splitView!.addSubview(leftContainer!)
        
        rightContainer = NSView(frame: .zero)
        splitView!.addSubview(rightContainer!)
        
        // Set min width for containers
        leftContainer!.addConstraint(NSLayoutConstraint(item: leftContainer!, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300.0))
        rightContainer!.addConstraint(NSLayoutConstraint(item: rightContainer!, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300.0))
        
        splitView!.adjustSubviews()
    }
    
    
    private func setupSlidesLayoutCurrent() {
        splitView?.isHidden = true
        
        currentSlideView = setupSlideView(in: self)
    }
    
    
    private func setupSlidesLayoutCurrentNext() {
        guard splitView != nil, leftContainer != nil, rightContainer != nil else { return }
        splitView?.isHidden = false
        
        // Left container: Setup current
        currentSlideView = setupSlideView(in: leftContainer!)
        
        // Right container: Setup next
        nextSlideView = setupSlideView(in: rightContainer!)
        
        splitView?.setHoldingPriority(NSLayoutConstraint.Priority(270.0), forSubviewAt: 0)
        splitView?.setHoldingPriority(NSLayoutConstraint.Priority(270.0), forSubviewAt: 1)
    }
    
    
    private func setupSlidesLayoutCurrentNotes() {
        guard splitView != nil, leftContainer != nil, rightContainer != nil else { return }
        splitView?.isHidden = false
        
        // Left container: Setup notes
        notesSlideView = setupSlideView(in: leftContainer!)
        
        
        // Right container: Setup current
        currentSlideView = setupSlideView(in: rightContainer!)
        
        splitView?.setHoldingPriority(NSLayoutConstraint.Priority(270.0), forSubviewAt: 0)
        splitView?.setHoldingPriority(NSLayoutConstraint.Priority(270.0), forSubviewAt: 1)
    }
    
    
    private func setupSlidesLayoutCurrentNotesText() {
        guard splitView != nil, leftContainer != nil, rightContainer != nil else { return }
        splitView?.isHidden = false
        
        // Left container: Setup notes
        setupNotesTextView(in: leftContainer!)
        
        // Right container: Setup current
        currentSlideView = setupSlideView(in: rightContainer!)
        
        splitView?.setHoldingPriority(NSLayoutConstraint.Priority(270.0), forSubviewAt: 0)
        splitView?.setHoldingPriority(NSLayoutConstraint.Priority(270.0), forSubviewAt: 1)
    }
    
    
    private func setupSlidesLayoutCurrentNextNotes() {
        guard splitView != nil, leftContainer != nil, rightContainer != nil else { return }
        splitView?.isHidden = false
        
        // Left container: Setup notes
        notesSlideView = setupSlideView(in: leftContainer!)
        
        // Right container: Setup current and next
        let (topContainer, bottomContainer) = createVerticallyStackedViews(in: rightContainer!)
        currentSlideView = setupSlideView(in: topContainer)
        nextSlideView = setupSlideView(in: bottomContainer)
    }
    
    
    func setupSlidesLayoutCurrentNextNotesText() {
        guard splitView != nil, leftContainer != nil, rightContainer != nil else { return }
        splitView?.isHidden = false
        
        // Left container: Setup notes
        setupNotesTextView(in: leftContainer!)
        
        // Right container: Setup current and next
        let (topContainer, bottomContainer) = createVerticallyStackedViews(in: rightContainer!)
        currentSlideView = setupSlideView(in: topContainer)
        nextSlideView = setupSlideView(in: bottomContainer)
    }
    
    
    /**
     Creates two vertically stacked containers in the given container.
     
     - returns:
     Two `NSView`'s, the first is the top container, the second is the bottom container.
     */
    func createVerticallyStackedViews(in container: NSView) -> (NSView, NSView) {
        // Create top container
        let topContainer = NSView()
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(topContainer)
        container.addConstraints([
            NSLayoutConstraint(item: topContainer, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: topContainer, attribute: .left, relatedBy: .equal, toItem: container, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: topContainer, attribute: .right, relatedBy: .equal, toItem: container, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: topContainer, attribute: .height, relatedBy: .equal, toItem: container, attribute: .height, multiplier: 0.5, constant: 0.0)])
        
        let bottomContainer = NSView()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(bottomContainer)
        container.addConstraints([
            NSLayoutConstraint(item: bottomContainer, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: bottomContainer, attribute: .left, relatedBy: .equal, toItem: container, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: bottomContainer, attribute: .right, relatedBy: .equal, toItem: container, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: bottomContainer, attribute: .height, relatedBy: .equal, toItem: container, attribute: .height, multiplier: 0.5, constant: 0.0)])
        
        return (topContainer, bottomContainer)
    }
    
    
    func setupSlideView(in container: NSView) -> SlideView {
        let slideView = SlideView(frame: .zero)
        slideView.page.setDocument(DocumentController.document)
        slideView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(slideView)
        container.addConstraints([
            NSLayoutConstraint(item: slideView, attribute: .left, relatedBy: .equal, toItem: container, attribute: .left, multiplier: 1.0, constant: padding),
            NSLayoutConstraint(item: slideView, attribute: .right, relatedBy: .equal, toItem: container, attribute: .right, multiplier: 1.0, constant: -padding),
            NSLayoutConstraint(item: slideView, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: padding),
            NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: slideView, attribute: .bottom, multiplier: 1.0, constant: padding)])
        
        return slideView
    }
    
    
    func setupNotesTextView(in container: NSView) {
        // Notes Editor setup
        notesEditor = NotesEditor(frame: .zero)
        notesEditor!.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(notesEditor!)
        container.addConstraints([
            NSLayoutConstraint(item: notesEditor!, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: notesEditor!, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: notesEditor!, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 0.9, constant: 0.0),
            NSLayoutConstraint(item: notesEditor!, attribute: .height, relatedBy: .equal, toItem: container, attribute: .height, multiplier: 0.8, constant: 0.0)
            ])
    }
}
